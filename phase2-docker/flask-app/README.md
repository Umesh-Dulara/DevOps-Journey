# 🐳 Flask Visitor Counter (Day 30 Mini-Project)

Flask web app with a PostgreSQL-backed visitor counter, orchestrated with Docker Compose.

## What's Inside

| File | Description |
|---|---|
| `app.py` | Flask app — increments and returns visit count from Postgres |
| `Dockerfile` | Single-stage build on `python:3.11-slim`, non-root user, gunicorn |
| `docker-compose.yml` | Runs Flask app + Postgres with custom network and persistent volume |
| `init.sql` | Creates `visitor_count` table and seeds initial row |
| `.env` | Database credentials and connection config |
| `.dockerignore` | Excludes build artifacts from image |
| `requirements.txt` | Flask, psycopg2-binary, gunicorn |

## Run It

```bash
docker compose up -d
curl http://localhost:5000       # each request increments the counter
curl http://localhost:5000/health
docker compose down
```

## Concepts Practiced

- Docker Compose multi-container apps
- PostgreSQL with persistent volumes
- `depends_on` with `service_healthy` condition
- Non-root user, environment variables, `.dockerignore`
