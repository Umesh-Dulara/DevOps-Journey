#!/bin/bash
set -euo pipefail

tem_file=$(mktemp /tmp/tempfile.XXXXXXXX --suffix=.txt)
ls > "$tem_file"

trap 'rm -rf "$tem_file" && echo "$tem_file was deleted"' EXIT
