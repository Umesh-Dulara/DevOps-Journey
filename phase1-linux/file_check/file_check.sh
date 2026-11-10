#!/bin/bash
check () { 
[[ -f "$1" && -r "$1" ]]
local status=$?
if [ $status -eq 0 ]; then
        echo "$1 exist and readable"
        return 0
else
        echo "$1 doesnt exist or unreadable to the current user"
        return $status
fi
}
check "/home/umesh-dulara/Desktop/devops-journey/devops_roadmap.md"

