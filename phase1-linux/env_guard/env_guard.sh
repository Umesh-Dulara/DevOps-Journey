#!/bin/bash
set -euo pipefail

check () {

local has_errors=0

if [ "$#" -eq 0 ]; then
	echo "Please enter atleast one argument"
	exit 1
fi

for arg in "$@"; do
if [ -v "$arg" ]; then
	if [ -n "${!arg}" ]; then
		echo "$arg is declaired and set"
	else
		echo "$arg is declaired.But its value is empty!"
		has_errors=1
	fi
else
	echo "$arg is not declaired!"
	has_errors=1
fi

done

if [ "$has_errors" -eq 1 ]; then
	exit 1
fi

}

check "$@"
