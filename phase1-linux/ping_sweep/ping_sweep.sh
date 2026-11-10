#!/bin/bash
set -euo pipefail

exec > >(tee -a /home/umesh-dulara/Desktop/devops-journey/phase1-linux/ping_sweep.log)

if [ "${1:-}" = "" ]; then
	echo "Please enter network prefix (e.g.: 192.168.1)"
	exit 1
fi


count=0
for i in {1..10}; do
	ping -c 1 $1.$i > /dev/null 2>&1 && host=0 || host=$?
		if [ $host -eq 0 ]; then
			echo "$1.$i Host is up!"
			count=$((count + 1))
		else
			echo "$1.$i Host is down!"
		fi
done

down=$((10 - count))
echo "Summery: $count hosts up, $down hosts down"
