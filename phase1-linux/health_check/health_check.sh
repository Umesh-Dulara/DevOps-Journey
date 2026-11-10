#!/bin/bash

path="/home/umesh-dulara/Desktop/devops-journey/phase1-linux"
day=$(date +%y%m%d_%H%M%S)
file="$path/health_$day.log"
exec > >(tee -a "$file")
set -euo pipefail

echo "==================================================="
echo "    System Health check - $(date '+%Y-%m-%d %H:%M')"
echo "    Host: $(hostname)"
echo "==================================================="

echo "CPU Usage $(echo "100 - $(top -bn1 | grep "%Cpu(s)" | awk '{print $8}')" | bc ) %"

echo "Memory: $(free -h | grep "Mem:" | awk '{gsub(/Gi/, ""); printf "%s%sG (%.0f%%)\n", $3, $2, ($3 / $2 * 100) }' ) "
echo "Disk Usage:"
df -h | grep -vE '^Filesystem|tmpfs|udev' | while read -r line; do
	usage=$(echo "$line" | awk '{print $5}' | sed 's/%//')
	mount=$(echo "$line" | awk '{print $6}')
	echo "       $mount   :   $usage"
done
echo "Top 5 Processes by CPU : "
echo "$(ps aux --sort=-%cpu | awk 'NR >= 2 && NR <= 6  {n = split($11, path, "/"); process = path[n]; printf "%-20s  %s %%\n", process,  $3 }' )"

echo "Network :"
ping  -c 1 8.8.8.8 > /dev/null 2>1&

if [[ $? -ne 0 ]]
then
	echo "Internet : Disconnected"
else
	echo "Internet : Connected"
fi



echo "log saved to : "$file""
echo "==================================================="
