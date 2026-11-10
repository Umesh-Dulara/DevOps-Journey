#!/bin/bash
set -euo pipefail

service_ch() {

if systemctl is-active "$1" >/dev/null; then
	echo "$1 is running"
	return 0
else
	echo "$1 is not running"
	return 1
fi

}


systemctl list-units --type=service --no-legend | head -n 3 | awk '{print $1}' | while read -r ser; do
service_ch "$ser" || true
done
