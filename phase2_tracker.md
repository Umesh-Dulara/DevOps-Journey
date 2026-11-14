# 🐳 Phase 2 — Docker & Containers
**Duration**: 2 weeks | **Daily**: 3 hrs | **Goal**: Containerize any application

---

## WEEK 4 — Docker Core

### ✅ Day 22 — What Are Containers?
**Concept**: Containers are isolated, lightweight environments that share the host kernel. They're NOT virtual machines.

```bash
# VM vs Container — the key difference:
# VM:        App → Guest OS → Hypervisor → Host OS → Hardware
# Container: App → Container Runtime → Host OS → Hardware
# Containers share the kernel. VMs each have their own OS.

# Why containers?
# 1. "Works on my machine" → works EVERYWHERE
# 2. Start in milliseconds (VMs take minutes)
# 3. Use MB of space (VMs use GB)
# 4. Consistent environments: dev = staging = production

# The container is just a process with:
# - Its own filesystem (from an image)
# - Its own network stack
# - Its own process tree (PID namespace)
# - Resource limits (cgroups)

# Key building blocks (Linux features you already know!):
# Namespaces — isolation (PID, network, mount, user)
# Cgroups    — resource limits (CPU, memory)
# Union FS   — layered filesystems (overlay2)
```

**Understand**: A container is NOT a VM. It's a process with isolation. The kernel is shared.

**Write in notes/day22.txt**:
```
## Day 22 - What Are Containers?
- VM vs Container: key difference =
- Why containers are faster than VMs:
- Three Linux features that make containers work:
- Something that surprised me:
```

---

### ✅ Day 23 — Installing Docker & CLI Basics
**Concept**: Docker is the tool that manages containers. The CLI is how you talk to it.

```bash
# Check if Docker is installed
docker --version
docker info

# If not installed:
# sudo apt update
# sudo apt install -y docker.io
# sudo systemctl start docker
# sudo systemctl enable docker
# sudo usermod -aG docker $USER   # run docker without sudo
# newgrp docker                    # apply group change NOW

# Your first container
docker run hello-world
# What just happened:
# 1. Docker looked for "hello-world" image locally
# 2. Didn't find it → pulled from Docker Hub
# 3. Created a container from that image
# 4. Ran the container → printed output
# 5. Container exited

# Run an interactive Ubuntu container
docker run -it ubuntu bash
# You're now INSIDE a container!
# Try these inside:
cat /etc/os-release
ls /
whoami               # you're root inside the container
ps aux               # only YOUR processes — isolation!
exit                 # leave the container

# List running containers
docker ps

# List ALL containers (including stopped)
docker ps -a

# Remove stopped containers
docker rm $(docker ps -aq)
```

---

### ✅ Day 24 — Images vs Containers
**Concept**: An image is a blueprint. A container is a running instance of that image.

```bash
# Think of it like:
# Image     = Class (the template)
# Container = Object (a running instance)

# Pull images from Docker Hub
docker pull nginx
docker pull alpine         # tiny Linux (~5MB!)
docker pull ubuntu:22.04   # specific version (tag)

# List downloaded images
docker images
# Notice: IMAGE ID, SIZE, TAG

# Run nginx web server
docker run -d --name my-nginx -p 8080:80 nginx
# -d         = detached (run in background)
# --name     = give it a name
# -p 8080:80 = map host port 8080 → container port 80

# Test it!
curl http://localhost:8080
# You should see the nginx welcome page

# Inspect a running container
docker inspect my-nginx | head -50
docker logs my-nginx
docker stats my-nginx       # live resource usage (Ctrl+C to exit)

# Execute a command inside a running container
docker exec -it my-nginx bash
ls /usr/share/nginx/html/    # nginx serves files from here
cat /usr/share/nginx/html/index.html
exit

# Stop and remove
docker stop my-nginx
docker rm my-nginx

# Remove an image
docker rmi nginx
```

---

### ✅ Day 25 — Writing Your First Dockerfile
**Concept**: A Dockerfile is a recipe that tells Docker how to build an image.

```bash
# Create a project directory
mkdir -p ~/devops-journey/phase2-docker/my-first-app
cd ~/devops-journey/phase2-docker/my-first-app
```

Create `app.py`:
```python
# app.py — simple Python web server
from http.server import HTTPServer, SimpleHTTPRequestHandler
import os

PORT = int(os.environ.get("PORT", 8000))

class Handler(SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        hostname = os.uname().nodename
        self.wfile.write(f"""
        <html>
        <body style="font-family: sans-serif; text-align: center; padding: 50px;">
            <h1>🐳 Hello from Docker!</h1>
            <p>Hostname: {hostname}</p>
            <p>Port: {PORT}</p>
        </body>
        </html>
        """.encode())

print(f"Server running on port {PORT}")
HTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
```

Create `Dockerfile`:
```dockerfile
# Dockerfile — recipe to build our image

# Step 1: Start from a base image
FROM python:3.11-slim

# Step 2: Set working directory inside container
WORKDIR /app

# Step 3: Copy files into the container
COPY app.py .

# Step 4: Tell Docker what port the app uses
EXPOSE 8000

# Step 5: Command to run when container starts
CMD ["python", "app.py"]
```

```bash
# Build the image
docker build -t my-first-app .
# -t = tag (name) the image
# .  = build context (current directory)

# Watch the output — each step creates a LAYER

# List your images
docker images | grep my-first-app

# Run it!
docker run -d --name my-app -p 8000:8000 my-first-app

# Test it
curl http://localhost:8000

# Check logs
docker logs my-app

# Clean up
docker stop my-app && docker rm my-app
```

**Understand**: Each line in the Dockerfile creates a layer. Docker caches layers — if nothing changed, it reuses the cache.

---

### ✅ Day 26 — Layers, Caching & Build Optimization
**Concept**: Image layers are cached. The order of your Dockerfile instructions matters for build speed.

```bash
cd ~/devops-journey/phase2-docker/my-first-app
```

Create `requirements.txt`:
```
flask==3.0.0
```

Update the Dockerfile — **BAD version** (slow rebuilds):
```dockerfile
# BAD — copying everything before installing deps
FROM python:3.11-slim
WORKDIR /app
COPY . .                          # copies ALL files
RUN pip install -r requirements.txt  # runs EVERY time ANY file changes
CMD ["python", "app.py"]
```

Now the **GOOD version** (fast rebuilds):
```dockerfile
# GOOD — copy requirements first, then the rest
FROM python:3.11-slim
WORKDIR /app

# Step 1: Copy ONLY requirements (changes rarely)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Step 2: Copy app code (changes often)
COPY app.py .

EXPOSE 8000
CMD ["python", "app.py"]
```

```bash
# Build with the good Dockerfile
docker build -t my-first-app:v2 .

# Now change app.py slightly and rebuild
# Docker will SKIP the pip install step — it's cached!
docker build -t my-first-app:v3 .
# Notice "CACHED" in the output for the pip install layer

# See image layers
docker history my-first-app:v3

# Check image size
docker images | grep my-first-app

# .dockerignore — like .gitignore but for Docker builds
# Create .dockerignore:
cat > .dockerignore << 'EOF'
__pycache__
*.pyc
.git
.env
.venv
node_modules
EOF
```

**Key rules**:
1. Put things that change LEAST at the top of the Dockerfile
2. Put things that change MOST at the bottom
3. Use `.dockerignore` to exclude junk from the build context

---

### ✅ Day 27 — Volumes & Bind Mounts
**Concept**: Containers are ephemeral — when removed, data is GONE. Volumes persist data.

```bash
# Problem: data disappears when container is removed
docker run -it --name test-data ubuntu bash
# Inside: echo "important data" > /data.txt && exit
docker rm test-data
# /data.txt is gone forever!

# Solution 1: Named volumes (Docker manages the storage)
docker volume create my-data
docker volume ls

docker run -it --name vol-test -v my-data:/app/data ubuntu bash
# Inside:
echo "this will survive" > /app/data/persist.txt
exit

docker rm vol-test

# Run a NEW container with the SAME volume
docker run -it --name vol-test2 -v my-data:/app/data ubuntu bash
cat /app/data/persist.txt    # data is still there!
exit
docker rm vol-test2

# Inspect volume
docker volume inspect my-data

# Solution 2: Bind mounts (map host directory → container)
mkdir -p ~/devops-journey/phase2-docker/shared-data

docker run -it \
  -v ~/devops-journey/phase2-docker/shared-data:/app/data \
  ubuntu bash
# Inside:
echo "from container" > /app/data/hello.txt
exit

# On host:
cat ~/devops-journey/phase2-docker/shared-data/hello.txt
# "from container" — the file exists on YOUR machine!

# When to use what:
# Named volumes → databases, persistent app data
# Bind mounts   → development (live code reload), sharing config files

# Clean up volumes
docker volume rm my-data
docker volume prune     # remove all unused volumes
```

---

### ✅ Day 28 — Docker Networking
**Concept**: Containers need to talk to each other and to the outside world. Docker provides network drivers.

```bash
# List networks
docker network ls
# You'll see: bridge, host, none

# bridge (default) — containers get their own IP, isolated from host
docker run -d --name web1 nginx
docker inspect web1 | jq '.[0].NetworkSettings.IPAddress'

# host — container uses the host's network directly (no port mapping needed)
docker run -d --name web-host --network host nginx
# Now nginx is on port 80 of YOUR machine directly
curl http://localhost:80
docker stop web-host && docker rm web-host

# none — no networking at all
docker run -d --name web-none --network none nginx
# This container has NO network access

# Custom networks — containers can find each other by NAME
docker network create my-network

docker run -d --name app-server --network my-network nginx
docker run -d --name db-server --network my-network alpine sleep 3600

# From db-server, reach app-server by name:
docker exec -it db-server sh
ping app-server -c 3     # resolves by container name!
wget -qO- http://app-server:80 | head -5
exit

# Clean up
docker stop app-server db-server web1 web-none 2>/dev/null
docker rm app-server db-server web1 web-none 2>/dev/null
docker network rm my-network

# Port mapping recap:
# -p 8080:80     → host:8080 maps to container:80
# -p 127.0.0.1:8080:80  → only accessible from localhost
# -P             → map ALL exposed ports to random host ports
```

---

### ✅ Day 29 — Docker Compose
**Concept**: `docker-compose` lets you define and run multi-container apps with a single YAML file.

```bash
mkdir -p ~/devops-journey/phase2-docker/compose-app
cd ~/devops-journey/phase2-docker/compose-app
```

Create `docker-compose.yml`:
```yaml
# docker-compose.yml — multi-container app definition

version: "3.8"

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro    # read-only bind mount
    depends_on:
      - api
    networks:
      - app-network

  api:
    build: ./api                            # build from Dockerfile
    ports:
      - "5000:5000"
    environment:
      - DB_HOST=database
      - DB_PORT=5432
    depends_on:
      - database
    networks:
      - app-network

  database:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: appuser
      POSTGRES_PASSWORD: secretpass
    volumes:
      - db-data:/var/lib/postgresql/data    # persist database
    networks:
      - app-network

volumes:
  db-data:                                  # named volume

networks:
  app-network:
    driver: bridge
```

Create the API service:
```bash
mkdir -p api
```

Create `api/app.py`:
```python
from http.server import HTTPServer, BaseHTTPRequestHandler
import json, os

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.end_headers()
        response = {
            "status": "healthy",
            "db_host": os.environ.get("DB_HOST", "unknown"),
            "message": "API is running in Docker Compose!"
        }
        self.wfile.write(json.dumps(response).encode())

print("API running on port 5000")
HTTPServer(("0.0.0.0", 5000), Handler).serve_forever()
```

Create `api/Dockerfile`:
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]
```

Create `html/index.html`:
```bash
mkdir -p html
cat > html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<body style="font-family: sans-serif; text-align: center; padding: 50px;">
    <h1>🐳 Docker Compose App</h1>
    <p>Nginx → API → PostgreSQL</p>
    <p>All running in containers!</p>
</body>
</html>
EOF
```

```bash
# Start everything
docker compose up -d
# Docker Compose builds, creates networks, volumes, and starts all containers

# Check status
docker compose ps

# View logs
docker compose logs          # all services
docker compose logs api      # specific service
docker compose logs -f       # follow live

# Test
curl http://localhost:8080   # nginx
curl http://localhost:5000   # api

# Stop everything
docker compose down

# Stop AND remove volumes (careful — deletes data!)
docker compose down -v
```

**Key commands**:
```bash
docker compose up -d       # start all services
docker compose down        # stop and remove
docker compose ps          # list services
docker compose logs -f     # follow logs
docker compose exec api bash   # shell into a service
docker compose build       # rebuild images
docker compose restart     # restart all services
```

---

### ✅ Day 30 — Week 4 Mini-Project: Dockerize a Web App
**Mini-Project**: Dockerize a Python Flask app with PostgreSQL using Docker Compose.

Create `~/devops-journey/phase2-docker/flask-app/`:
- `app.py` — Flask web app that connects to PostgreSQL
- `requirements.txt` — Python dependencies
- `Dockerfile` — to build the app image
- `docker-compose.yml` — to run app + database together
- `init.sql` — initialize database tables

**Requirements**:
1. Flask app that shows a visitor counter (stored in PostgreSQL)
2. Each page visit increments the counter
3. Database data persists even if containers are removed (use volumes)
4. App and database on a custom Docker network
5. Use environment variables for database credentials (don't hardcode)
6. Use `.dockerignore` to keep the image clean

Try building it yourself first! If you get stuck, ask for hints.

---

## WEEK 5 — Docker in Practice

### ✅ Day 31 — Docker Hub & Registries
**Concept**: Docker Hub is the "GitHub for container images". You push images there so others can pull them.

```bash
# Login to Docker Hub
docker login
# Enter your Docker Hub username and password

# Tag your image for Docker Hub
# Format: docker tag local-image:tag username/repo:tag
docker tag my-first-app:v3 yourusername/my-first-app:v3
docker tag my-first-app:v3 yourusername/my-first-app:latest

# Push to Docker Hub
docker push yourusername/my-first-app:v3
docker push yourusername/my-first-app:latest

# Now anyone can pull it:
# docker pull yourusername/my-first-app:latest

# Search Docker Hub
docker search nginx
docker search --filter is-official=true nginx

# Image tagging best practices:
# - Always use specific tags in production: nginx:1.25.3
# - Never rely on :latest in production — it changes!
# - Use semantic versioning: myapp:1.0.0, myapp:1.0.1
# - Tag with git SHA for traceability: myapp:abc1234

# Private registries (not Docker Hub):
# AWS ECR, Google GCR, GitHub Container Registry (ghcr.io)
# Self-hosted: Harbor, Nexus
# We'll use these in Phase 3 and 5
```

---

### ✅ Day 32 — Multi-Stage Builds
**Concept**: Multi-stage builds create smaller, more secure production images by separating the build environment from the runtime.

```bash
mkdir -p ~/devops-journey/phase2-docker/multi-stage
cd ~/devops-journey/phase2-docker/multi-stage
```

Create `app.go` (a simple Go web server):
```go
package main

import (
    "fmt"
    "net/http"
    "os"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        hostname, _ := os.Hostname()
        fmt.Fprintf(w, "Hello from Go! Hostname: %s\n", hostname)
    })
    fmt.Println("Server running on :8080")
    http.ListenAndServe(":8080", nil)
}
```

**Single-stage Dockerfile** (BAD — huge image):
```dockerfile
# BAD: includes entire Go toolchain in final image
FROM golang:1.21
WORKDIR /app
COPY app.go .
RUN go build -o server app.go
CMD ["./server"]
# Image size: ~800MB! All that Go toolchain is wasted.
```

**Multi-stage Dockerfile** (GOOD — tiny image):
```dockerfile
# GOOD: build in one stage, run in another

# Stage 1: BUILD
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY app.go .
RUN go build -o server app.go

# Stage 2: RUN (only the binary, no toolchain)
FROM alpine:3.19
WORKDIR /app
COPY --from=builder /app/server .
EXPOSE 8080
CMD ["./server"]
# Image size: ~15MB! Just the binary + minimal OS.
```

```bash
# Build both and compare sizes
docker build -t go-app-fat -f Dockerfile.single .    # if you saved the bad one
docker build -t go-app-slim -f Dockerfile .

docker images | grep go-app
# go-app-fat   ~800MB
# go-app-slim  ~15MB

# Same app, fraction of the size!
# Smaller image = faster pulls, less attack surface, less storage

# Run the slim version
docker run -d --name go-app -p 8080:8080 go-app-slim
curl http://localhost:8080
docker stop go-app && docker rm go-app
```

**Multi-stage for Python**:
```dockerfile
# Stage 1: Install dependencies
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY . .
ENV PATH=/root/.local/bin:$PATH
CMD ["python", "app.py"]
```

---

### ✅ Day 33 — Health Checks & Container Best Practices
**Concept**: Production containers need health checks, non-root users, and security hardening.

```dockerfile
# Health checks — Docker monitors if your app is actually working
FROM python:3.11-slim
WORKDIR /app
COPY app.py .

# HEALTHCHECK: Docker will run this command periodically
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8000/ || exit 1

EXPOSE 8000
CMD ["python", "app.py"]
```

```bash
# Run and check health status
docker run -d --name health-test -p 8000:8000 my-health-app
docker ps     # STATUS column shows "healthy" or "unhealthy"
docker inspect health-test | jq '.[0].State.Health'
```

**Security best practices**:
```dockerfile
# 1. Don't run as root!
FROM python:3.11-slim

# Create a non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /app
COPY --chown=appuser:appuser app.py .

# Switch to non-root user
USER appuser

CMD ["python", "app.py"]
```

```bash
# 2. Use specific image tags (not :latest)
# BAD:  FROM python:latest
# GOOD: FROM python:3.11.7-slim-bookworm

# 3. Minimize layers — combine RUN commands
# BAD:
# RUN apt-get update
# RUN apt-get install -y curl
# RUN apt-get clean

# GOOD:
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends curl && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# 4. Use slim/alpine base images
# python:3.11        → ~900MB
# python:3.11-slim   → ~130MB
# python:3.11-alpine → ~50MB (but can have compatibility issues)

# 5. Scan for vulnerabilities
docker scout cves my-first-app:v3     # Docker Scout (if available)
# Or use: trivy image my-first-app:v3
```

---

### ✅ Day 34 — Docker Commands Cheat Sheet & Deep Dive
**Concept**: Master the CLI. These are the commands you'll use every day.

```bash
# === CONTAINER LIFECYCLE ===
docker run [options] image          # create + start
docker create image                 # create without starting
docker start container              # start a stopped container
docker stop container               # graceful stop (SIGTERM → SIGKILL)
docker kill container               # force stop (SIGKILL immediately)
docker restart container            # stop + start
docker rm container                 # remove (must be stopped)
docker rm -f container              # force remove (even if running)

# === INSPECTION ===
docker ps                           # running containers
docker ps -a                        # all containers
docker logs container               # stdout/stderr
docker logs -f --tail 100 container # follow last 100 lines
docker inspect container            # full JSON details
docker stats                        # live resource usage
docker top container                # processes inside container
docker diff container               # filesystem changes

# === IMAGES ===
docker images                       # list images
docker pull image:tag               # download image
docker build -t name:tag .          # build from Dockerfile
docker push name:tag                # push to registry
docker rmi image                    # remove image
docker image prune                  # remove unused images
docker system prune -a              # remove EVERYTHING unused

# === VOLUMES ===
docker volume create name
docker volume ls
docker volume inspect name
docker volume rm name
docker volume prune

# === NETWORKS ===
docker network create name
docker network ls
docker network inspect name
docker network connect net container
docker network disconnect net container

# === COMPOSE ===
docker compose up -d
docker compose down
docker compose ps
docker compose logs -f
docker compose exec service cmd
docker compose build
docker compose pull
```

**Useful flags you should know**:
```bash
docker run -d                    # detached (background)
docker run -it                   # interactive + TTY (shell access)
docker run --name myapp          # name the container
docker run -p 8080:80            # port mapping
docker run -v vol:/path          # mount volume
docker run -e KEY=VALUE          # set environment variable
docker run --env-file .env       # load env vars from file
docker run --rm                  # auto-remove on exit
docker run --restart unless-stopped  # restart policy
docker run --memory 512m         # limit memory
docker run --cpus 1.5            # limit CPU
```

---

### ✅ Day 35 — Week 5 Mini-Project: Production-Ready Docker Image
**Mini-Project**: Build a production-ready Docker image and push to Docker Hub.

**Requirements**:
1. Choose your Flask app from Day 30 (or build a new one)
2. Write a **multi-stage Dockerfile** that:
   - Installs dependencies in a builder stage
   - Copies only what's needed to a slim runtime stage
   - Runs as a **non-root user**
   - Has a **HEALTHCHECK**
   - Uses a `.dockerignore`
3. Tag the image with semantic versioning (`yourusername/app:1.0.0`)
4. Push to Docker Hub
5. Write a `docker-compose.yml` that runs the full stack (app + database)
6. Document the project in a `README.md`

**Bonus challenges**:
- Add a `Makefile` with targets: `build`, `run`, `push`, `clean`
- Scan the image for vulnerabilities
- Get the image under 100MB

Try building it yourself first! Review your work against the Day 33 best practices checklist.

---

## 🏁 Phase 2 Complete — What You Now Know

- [ ] What containers are and how they differ from VMs
- [ ] Docker CLI: run, stop, rm, logs, exec, inspect
- [ ] Images vs containers (blueprint vs instance)
- [ ] Writing Dockerfiles from scratch
- [ ] Layer caching and build optimization
- [ ] Volumes (named volumes + bind mounts)
- [ ] Docker networking (bridge, host, custom networks)
- [ ] Docker Compose for multi-container apps
- [ ] Docker Hub: push, pull, tag images
- [ ] Multi-stage builds for smaller images
- [ ] Container security: non-root users, health checks, image scanning
- [ ] Production-ready container practices

**Next**: Phase 3 — CI/CD Pipelines 🚀
