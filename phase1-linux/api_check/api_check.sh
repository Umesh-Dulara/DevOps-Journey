#!/bin/bash
set -euo pipefail
user=$1
error_handle () {

echo "curl request failed"

}

trap 'error_handle' ERR

response=$(curl -s -w "\n%{http_code}" https://api.github.com/users/$1/repos)
http_code=$(echo "$response" | tail -n 1)
json=$(echo "$response" | sed '$d')

star () {

if [[ $http_code -ge 200 && $http_code -le 300 ]]; then
	if [[ $(echo "$json" | jq '. | length') -gt 0 ]]; then
		echo "Star count"
		echo "$json" | jq -r '.[] | "\(.name): \(.stargazers_count) stars"'
	else
		echo "$user has no public repositories."
	fi
else
	echo "http error $http_code" && exit 1
fi
}

star



