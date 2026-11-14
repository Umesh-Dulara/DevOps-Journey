# 🚀 Push & Release

Demonstrates Docker Hub push and release workflow — tagging images and pushing them to a registry.

## What's Inside

| File | Description |
|---|---|
| `Dockerfile` | Builds a Python web server image using `python:3.11-slim` |
| `server.py` | Simple HTTP server showing hostname and port |
| `push.sh` | Tags and pushes the image to Docker Hub (takes image name and version as args) |

## Run It

```bash
# Login to Docker Hub first
docker login

# Build the image
docker build -t my-web .

# Push (takes image name + version as arguments)
bash push.sh my-web 1.0.0

# --help for usage info
bash push.sh --help
```

## Concepts Practiced

- Docker Hub as a container registry
- Image tagging (`docker tag`)
- Pushing images (`docker push`)
- Semantic versioning and `:latest` tag management
