#!/bin/bash
set -euo pipefail

user="yourusername"


if [ $# = 0 ];then
	echo "No argument has passed"
	exit 1
elif [[ $# = 1 && "$1" == "--help" ]]; then 
	echo "Enter your image name and version as 2 argument"
	echo "Argument 1 = image name   Argument 2 = version"
	exit 0
elif [ $# != 2 ]; then
	echo "[ERROR]: Number of argument should be 2 !"
	exit 1
fi

name="${1,,}"
version="${2,,}"
image="$name:$version"
latest="$name:latest"

pushing () {

docker tag "$1" "$user"/"$image" > /dev/null 2>&1 || { echo "[ERROR] : Local image $1 was not found !"; exit 1; }
docker tag "$1" "$user"/"$latest" > /dev/null 2>&1 || { echo "[ERROR] : Failed to tag latest"; exit 1; }
docker push "$user"/"$image" > /dev/null 2>&1 && echo "$image: Pushed" || { echo "[ERROR] : Failed to push"; exit 1; }
docker push "$user"/"$latest" > /dev/null 2>&1 && echo "$image: Pushed" || { echo "[ERROR] : Failed to push"; exit 1; }

}

pushing "$@"
