#!/bin/bash
set -euo pipefail



if [ $# -eq 0 ]; then
        echo "No arguments has passed ! Please Enter valid argument(cpu/mem/disk)"
        exit 1

elif [[ $1 != "cpu" && $1 != "mem" && $1 != "disk" ]]; then
        echo "Please Enter valid argument(cpu/mem/disk)"
        exit 1

elif [ $1 == "cpu" ]; then
	echo "Current CPU Usage : $(echo "100 - $(top -bn1 | grep "%Cpu(s)" | awk '{print $8}')" | bc ) %"

elif [ $1 == "mem" ]; then
	usage=$(free -h | grep "Mem:" | awk '{gsub(/Gi/,""); print int($3 / $2 * 100) } ')
	if [ $usage -gt 80 ];then
		echo "Warning ! Memory usage is higher than 80%"
	else
		echo "Memory Usage is Ok"
	fi

elif [ $1 == "disk" ]; then
	df -h | grep -vE '^Filesystem|tmpfs|udev' | awk '{usage=$5; gsub(/%/,"",usage);
		if ( int(usage) >= 90 ) {
			print "WARNING! Partition " $6 " (" $1 ") is at " $5 " usage"}}'


fi
