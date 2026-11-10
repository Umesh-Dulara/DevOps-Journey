#!/bin/bash


response=$(curl -s -w "\n%{http_code}" https://httpbin.org)
http_code=$(echo "$response" | tail -n 1)
json_body=$(echo "$response" | sed '$d')
if [[ http_code -ge 200 && http_code -le 300 ]]; then
        $json_body | jq '.status.Host'
else
        echo "HTTP error code $http_code"
fi

