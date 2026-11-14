#!/bin/bash
set -euo pipefail

echo "Starting Container 1"
docker run --rm ubuntu bash -c "
host=\$(hostname)
echo \"Host name : \$host\" 
mkdir \"container-1\"
ls
"

echo "Starting Container 2"

docker run --rm ubuntu bash -c "
host=\$(hostname)
echo \"Host name : \$host\" 
mkdir \"container-2\"
ls
"
