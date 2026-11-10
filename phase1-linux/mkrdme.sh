#!/bin/bash
set -euo pipefail

me="$(pwd)"
echo "$me"

ls -la | awk 'NR > 3 {print $9}' | while read -r line; do 
	cd "$me/$line" && touch README.MD && echo "Complete"
done

