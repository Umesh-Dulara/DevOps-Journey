# 🔄 Docker Lifecycle

Demonstrates the full container lifecycle — build, run, test, and cleanup — automated with a bash script.

## What's Inside

| File | Description |
|---|---|
| `docker_life.sh` | Walks through build → run → curl test → cleanup with an EXIT trap |

## Run It

```bash
bash docker_life.sh
```

The script uses `trap cleanup EXIT` to guarantee container and image removal even if the script fails.

## Concepts Practiced

- Container lifecycle (`docker build`, `run`, `stop`, `rm`, `rmi`)
- Port mapping and HTTP testing with `curl`
- Bash `trap` for guaranteed resource cleanup
