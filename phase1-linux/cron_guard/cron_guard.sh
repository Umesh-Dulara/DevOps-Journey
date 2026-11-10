#!/bin/bash
set -euo pipefail

file=/tmp/sleep.lock

exec 200>/tmp/sleep.lock
flock -n 200 || { echo "An instance is running"; exit 1; }

echo "command is running ..."
sleep 1m
echo "done"
