#!/bin/bash
set -euo pipefail

echo "Host Name"
hostname

echo "Processes inside Host"
ps -e -o pid,comm | head -n 10  

echo "Files inside Host /Desktop"

ls ~/Desktop

docker run --rm ubuntu bash -c "
    apt-get update && apt-get install -y procps 2>/dev/null && \
    echo '--- Container ID ---' && \
    hostname && \
    echo '--- Processes inside container ---' && \
    ps -e -o pid,comm | head -n 10 && \
    echo '--- Files inside Container /Desktop ---' && \
    ls ~/Desktop 2>/dev/null || echo 'No Desktop folder found (Normal for a minimal server OS)'
"
