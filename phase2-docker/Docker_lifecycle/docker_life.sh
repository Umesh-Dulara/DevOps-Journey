#!/bin/bash

image_name="custom-web"
container="my"
cleanup () {
echo "Removing the container $container and the image $image_name"
docker stop "$container" > /dev/null 2>&1
docker rm "$container" > /dev/null 2>&1
docker rmi -f "$image_name" > /dev/null 2>&1
} 


trap cleanup EXIT

echo "Building the image"
docker build -t custom-web . > /dev/null 2>&1

echo "Starting the container"
docker run --name my -p 8080:80 -d custom-web >/dev/null


sleep 5

echo "Running Containers"
docker ps


echo "checking reachability with curl"

if curl -s --fail "http://localhost:8080" > /dev/null; then
	echo "Container is running and reachable"
else
	echo "Container is not reachable"
	exit 1
fi

