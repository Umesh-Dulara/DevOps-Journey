# 🔒 Linux Namespace Isolation

Proves that containers are just Linux processes with namespace isolation — using `unshare` to create a new PID namespace without Docker.

## What's Inside

| File | Description |
|---|---|
| `isolat.sh` | Compares host process tree vs an `unshare`-d PID namespace |

## Run It

```bash
sudo bash isolat.sh
```

The script shows the host's full process list, then uses `unshare --pid --fork --mount-proc` to create an isolated PID namespace where the shell sees itself as PID 1 — the same mechanism Docker uses under the hood.

## Concepts Practiced

- Linux PID namespaces (`unshare`)
- How containers achieve process isolation
- `/proc` mount isolation
- Containers are processes, not VMs
