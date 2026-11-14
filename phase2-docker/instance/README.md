# 📦 Container Instances

Demonstrates that containers are ephemeral — each run starts fresh from the image. Changes in one container don't affect another.

## What's Inside

| File | Description |
|---|---|
| `instance.sh` | Runs two separate Ubuntu containers, creates files in each, proves they're isolated |

## Run It

```bash
bash instance.sh
```

Container 1 creates a folder. Container 2 starts from the same image — the folder doesn't exist. Each container gets its own copy-on-write filesystem layer.

## Concepts Practiced

- Container ephemerality (data lost on removal)
- Copy-on-write filesystem layers
- Images vs container instances
