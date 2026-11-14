# 🌐 My-Web

A minimal static web server — Nginx serving a custom HTML page inside a Docker container.

## What's Inside

| File | Description |
|---|---|
| `dockerfile` | Builds an Nginx image that serves `index.html` |
| `index.html` | Simple "Hello world" web page |

## Run It

```bash
docker build -t my-web .
docker run -d -p 8080:80 my-web
curl http://localhost:8080
```

## Concepts Practiced

- Writing a Dockerfile (`FROM`, `COPY`, `EXPOSE`)
- Nginx as a static file server
- Port mapping (host:container)
