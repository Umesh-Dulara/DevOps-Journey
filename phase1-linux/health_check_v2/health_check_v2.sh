#!/bin/bash
set -euo pipefail


JSON_ONLY="false"
service_list=""

#used cyan because blue is hard to see on dark background
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;36m'
 
log_msg () {

local level="$1"
local msg="$2"
local color=""
 
case "$level" in
         "SUCCESS") color="$GREEN" ;;
         "ERROR") color="$RED" ;;
         "WARN") color="$YELLOW" ;;
         "INFO") color="$BLUE" ;;
esac

echo -e "${color} [$level] ${msg}${NC}" 
echo "[$day] [$level] $msg" >> "$log_file"
 
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV="$script_dir/.health.env"

if [ -f "$ENV" ]; then
	source "$ENV"
else
	echo "ERROR" ".env file $ENV not found !"
	exit 1
fi

day=$(date '+%Y-%m-%d %H:%M:%S')

file_check () {
if [ ! -d "$tmp_path" ]; then
	mkdir "$tmp_path"
fi

if [[ -d "$log_path" && -w "$log_path" ]]; then
	if [ ! -d "$log_path/healthlog" ]; then 
		mkdir -p "$log_path/healthlog"
	fi
	log_file="$log_path/healthlog/health_check_log.log"
else
	log_file="$script_dir/health_check_log.log" 
	log_msg "WARN" "You dont have permission write to $log_path !"
	log_msg "WARN" "Log file is now in $log_file"
fi

tmp_file=$(mktemp -p "$tmp_path" --suffix=".txt" "tmp_XXXXXX")


}

clean_up () {

rm -f "$tmp_file" && rmdir "$tmp_path" > /dev/null

}

trap clean_up EXIT

cpu_check () {
echo "============================================================="
echo "                    CPU Usage"
echo "============================================================="
local cpu_usage="$(echo "100 - $(top -bn1 | grep "%Cpu(s)" | awk '{print $8}')" | bc )"
if awk "BEGIN { if ($cpu_usage > 80) exit 0; else exit 1}"; then
	log_msg "WARN" "CPU usage is at $cpu_usage %"
	level="High"
else
	log_msg "INFO" "CPU usage is at $cpu_usage %"
	level="Normal"
fi

jq -n \
	--arg lvl "$level" \
	--argjson use "$cpu_usage" \
	'{cpu: {level: $lvl, usage: $use}}' >> "$tmp_file"

return 0
}

mem_check () {
echo "============================================================="
echo "                    Memory Usage"
echo "============================================================="

read -r -a mem_usage < <(free -h | grep "Mem:" | awk '{print $3, $2 }' | sed 's/Gi//g')

percent=$(awk "BEGIN {printf \"%.2f\", ${mem_usage[0]}/${mem_usage[1]} * 100}")

if awk "BEGIN { if ($percent > 80) exit 0; else exit 1}"; then
	log_msg "WARN" "Memory usage is at $percent %"
	level="High"
else
	log_msg "INFO" "Memory usage is at $percent %"
	level="Normal"
fi

jq -n \
	--arg lvl "$level" \
	--argjson use "$percent" \
	'{memory: {level: $lvl, usage: $use}}' >> "$tmp_file"

log_msg "INFO" "${mem_usage[0]} GB used out of ${mem_usage[1]} GB "

}

disk_check () {
echo "============================================================="
echo "                    Disk Usage"
echo "============================================================="
local line
df -h | grep -vE '^Filesystem|tmpfs|udev' | while read -r line; do
	local usage=$(echo "$line" | awk '{print $5}' | sed 's/%//')
	local mount=$(echo "$line" | awk '{print $6}')
	local level="Normal"
	if [ "$usage" -gt 80 ]; then
		log_msg "WARN" "$mount is at $usage %"
		level="High"
	else 
		log_msg "INFO" "$mount is at $usage %"
	fi

jq -n \
	--arg mnt "$mount" \
	--arg lvl "$level" \
	--argjson use "$usage" \
	'{disks: [{mount: $mnt, Level: $lvl, usage_pct: $use}]}' >> "$tmp_file"

done 

}

process_check () {
echo "============================================================="
echo "                    High demanding processes"
echo "============================================================="

local line
ps aux --sort=-%cpu --no-headers | while read -r line;do
	local count=0
	if [ "$count" -lt 5 ]; then
		local usage=$(echo "$line" | awk '{print $3}')
		local process=$(basename $(echo "$line" | awk '{print $11}'))
		count=$(( count + 1 ))
		log_msg "INFO" "$process : $usage %"
		jq -n \
			--arg name "$process" \
			--argjson cpu "$usage" \
			'{processes: [{process: $name, usage: $cpu}]}' >> "$tmp_file"
	fi
done
}

network_check () {
echo "============================================================="
echo "                    Connection Check"
echo "============================================================="

local status="UP"
if ping -c 1 -w 7 8.8.8.8 > /dev/null 2>&1; then
	log_msg "SUCCESS" "Network connection is up"
else
	log_msg "WARN" "Network connection is down !"
	status="DOWN"
fi

jq -n \
	--arg stat "$status" \
	'{network_status: $stat}' >> "$tmp_file"

}

service_check () {
echo "============================================================="
echo "                    Service Check"
echo "============================================================="


if [ -z "$service_list" ]; then
	log_msg "WARN" "No services specified"
	log_msg "WARN" "Continue with default values"
	service_list="$HEALTH_CHECK_SERVICES"
fi

for service in $service_list; do
	local status="DOWN"
	if systemctl is-active --quiet "$service"; then
		log_msg "SUCCESS" "$service is running"
		status="RUNNING"
	else
		log_msg "WARN" "$service is down"
	fi

	jq -n \
		--arg ser "$service" \
		--arg stat "$status" \
		'{services: [{service: $ser, status: $stat}]}' >> "$tmp_file"

done
}

mk_json() {

jq -s '

	reduce .[] as $item ({};
		reduce ($item | keys_unsorted[]) as $k (.;
			if ($item[$k] | type) == "array" then
				.[$k] += $item[$k]
			else
				.[$k] = $item[$k]
			end
			)
		)

' "$tmp_file" > "$script_dir"/"$day"_report.json 

}

show_help () {

echo "Usage: $0 [OPTIONS]"
echo "  --cpu         Run CPU checks only"
echo "  --mem         Run Memory checks only"
echo "  --disk        Run Disk checks only"
echo "  --net         Run Network checks only"
echo "  --proc        Run Process checks only"
echo "  --ser         Run service checks only"
echo "  --json-only   Create json report without terminal output"
echo "  --json        create a json report for custom check.combine it with one or more flags (--net --json)"
exit 0
}



GEN_JSON=false
RUN_ALL=true
RUN_CPU=false
RUN_MEM=false
RUN_NET=false
RUN_SER=false
RUN_DISK=false
RUN_PROC=false
JSON_ONLY=false

while [[ $# -gt 0 ]]; do
	case "$1" in
		--help)
			show_help
			shift
			;;
		--cpu)
			RUN_CPU=true
			RUN_ALL=false
			shift
			;;
		--mem)
			RUN_MEM=true
			RUN_ALL=false
			shift
			;;
                --disk)
                        RUN_DISK=true
			RUN_ALL=false
			shift
                	;;
                --net)
                        RUN_NET=true
			RUN_ALL=false
			shift
                	;;
                --proc)
                        RUN_PROC=true
			RUN_ALL=false
			shift
                	;;
                --service)
                        RUN_SER=true
			RUN_ALL=false
			next_arg="${2:-}"
			if [[ -n "$next_arg" && "$next_arg" != --* ]]; then
				service_list="$next_arg"
				shift 2
			else
				log_msg "WARN" "--service requires a service name argument"
				log_msg "WARN" "Continue with default services"
				shift 1
			fi
                	;;
                --json-only)
			JSON_ONLY=true
			GEN_JSON=true
			shift
                	;;
		--json)
			GEN_JSON=true
			shift
			;;
		*)
			echo "Unknown option: $1"
			show_help
			exit 1
			;;
	esac
done


if [ "$JSON_ONLY" = true ]; then
          exec 3>&1 > /dev/null
fi

echo "============================================================="
echo "      $(hostname) System Health Check - $day"
echo "============================================================="

file_check

if [[ "$RUN_ALL" == true ]]; then
	cpu_check
	mem_check
	disk_check
	process_check
	network_check
	service_check "$service_list"
	mk_json
else
	[[ "$RUN_CPU" == true ]] && cpu_check
	[[ "$RUN_MEM" == true ]] && mem_check
	[[ "$RUN_DISK" == true ]] && disk_check
	[[ "$RUN_NET" == true ]] && network_check
	[[ "$RUN_PROC" == true ]] && process_check
	[[ "$RUN_SER" == true ]] && service_check "$service_list"
	[[ "$GEN_JSON" == true ]] && mk_json
fi

