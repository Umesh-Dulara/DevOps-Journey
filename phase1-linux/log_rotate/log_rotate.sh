#!/bin/bash
set -euo pipefail

trap "echo 'Which part of do not interrupt that you dont understand?'" SIGINT
trap 'echo "$num_of_logs files archived out of $count"' EXIT

count=0
num_of_logs=0
DRY_RUN=true
#4 is used because there are no log files older than 7 days in phase1 directory
log_files=$( find "$1" -name "*.log" -type f -mtime +4 ) 
LOG_DIR="${1:-$HOME/devops-journey/notes}"
num_of_logs=$(wc -l <<< "$log_files")

if [ ! -d "$1/archive" ]; then
	mkdir "$1"/archive || { echo "Failed to create subdirectory"; exit 1; }
fi

create_zip () {

if [ -z "$log_files" ]; then
	echo "No logs to rotate."
	return 0
else 
	while read -r line; do
	file="$1/archive/$(basename "$line" .log)_$(date +%Y-%m-%d).log.gz"
	if [ "$DRY_RUN" = true  ]; then
		echo "$file"
	else
		gzip -c "$line" > "$file" || { echo "CRITICAL! FAILED TO CREATE BACKUP!"; exit 1; } 
	fi
	count=$((count + 1))
	done <<< "$log_files" 
	return 0
fi

}


remove () {
if [ "$DRY_RUN" = true  ]; then
	echo "[DRY_RUN] The following files would be deleted."
	echo "$log_files" | xargs -d '\n' ls -l | awk '{print $9}'
else
	xargs -d '\n' rm -f <<< "$log_files" || { echo "Failed to delete original files. Please check your permissions"; exit 1; }
	return 0
fi
}



echo "Zipping files.Please DO NOT INTERRUPT!"

if [ -z "$log_files"  ]; then
	echo "No log files to rotate"
	exit 0
fi

if [ "$DRY_RUN" = true ]; then
	echo "[DRY_RUN] Following files would be created"
fi

create_zip "$1" && remove "$log_files"


