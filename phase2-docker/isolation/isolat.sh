#!/bin/bash
set -euo pipefail

o_proc=$(ps aux | head -n 10)
i_proc=$(unshare --pid --fork --mount-proc bash -c "ps aux")

echo "$o_proc"
echo "$i_proc"

#regular ps aux shows all system processes in the host machine.but unshare output only show ps aux as PID 1.This proves containers arent same as VMs.Instead linux kernal hides host processes from the container by giving it an isolated PID namespace and private /proc mount
