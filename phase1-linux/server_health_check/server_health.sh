#!/bin/bash
set -euo pipefail

disk_check () {
local server="$1"
ssh -n -o ConnectionTimeout=5 user@"$server" "df -h | grep '/$'" && echo "$1"
}

for arg in "$@"; do 
	if ssh -n -o ConnectionTimeout=5 user@$arg 2> /dev/null; then 
	disk_check "$arg"
	else
	echo "Failed to SSH into $arg"
	fi
done
