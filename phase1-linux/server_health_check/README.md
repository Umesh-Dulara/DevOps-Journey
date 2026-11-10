# server_health.sh

Connects to specified remote servers over SSH to check the root filesystem disk usage. It verifies SSH reachability with a connection timeout before running the disk check.

## Usage

```bash
./server_health.sh <server1> [server2 ...]
```
