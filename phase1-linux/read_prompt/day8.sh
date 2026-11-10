#!/bin/bash
set -euo pipefail

if [ -n "$1" ]; then
	name="$1"
else
	read -r -p "Enter Your name : " name
fi

echo " Hello, $name ! Today is $(date) "
exit 0
