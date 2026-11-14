# 🔍 Container Isolation Demo

Proves that Docker containers are isolated from the host — different hostname, different process tree, different filesystem.

## What's Inside

| File | Description |
|---|---|
| `contain.sh` | Compares host vs container environment (hostname, processes, filesystem) |

## Run It

```bash
bash contain.sh
```

The script runs host commands first, then launches an ephemeral Ubuntu container and runs the same checks inside — showing they see completely different worlds.

## Concepts Practiced

- Container isolation (PID, filesystem, hostname)
- Ephemeral containers (`docker run --rm`)
- Host vs container process visibility
