# Health Check v2

A modular server health monitoring script built in Bash. Checks CPU, memory, disk, network, running processes, and systemd services — with color-coded terminal output, persistent logging, and optional JSON report generation.

This was the final project for Phase 1 of my DevOps learning journey.

## What It Does

- **CPU** — Reads current CPU usage via `top` and warns if it crosses 80%
- **Memory** — Parses `free -h` output to calculate memory usage percentage
- **Disk** — Iterates over all mounted filesystems and flags any partition above 80%
- **Processes** — Lists the top CPU-consuming processes using `ps aux`
- **Network** — Pings `8.8.8.8` to verify internet connectivity
- **Services** — Checks if specified systemd services (e.g. nginx, ssh, cron) are running

Every check logs results to a timestamped log file and can optionally export a merged JSON report using `jq`.

## Usage

Run all checks:

```bash
./health_check_v2.sh
```

Run specific checks:

```bash
./health_check_v2.sh --cpu --mem --disk
./health_check_v2.sh --net --proc
./health_check_v2.sh --service "nginx ssh"
```

Generate a JSON report alongside terminal output:

```bash
./health_check_v2.sh --json
```

Generate JSON only (suppress terminal output):

```bash
./health_check_v2.sh --json-only
```

Show help:

```bash
./health_check_v2.sh --help
```

### All Flags

| Flag | Description |
|---|---|
| `--cpu` | Run CPU check only |
| `--mem` | Run memory check only |
| `--disk` | Run disk check only |
| `--net` | Run network connectivity check only |
| `--proc` | Run top processes check only |
| `--service <list>` | Check specific services (space-separated, quoted) |
| `--json` | Generate a JSON report for the selected checks |
| `--json-only` | Generate JSON report without any terminal output |
| `--help` | Show usage information |

Flags can be combined. If no check flags are passed, all checks run by default.

## Configuration

The script reads from `.health.env` in the same directory:

```
log_path="/var/log"
tmp_path="/var/tmp/health.lock"
HEALTH_CHECK_SERVICES="nginx ssh cron"
```

- `log_path` — Where log files are written (falls back to the script directory if not writable)
- `tmp_path` — Temp directory for intermediate JSON fragments (cleaned up on exit via `trap`)
- `HEALTH_CHECK_SERVICES` — Default services to check when `--service` is used without arguments

## How It Works

1. Sources the `.health.env` config file
2. Creates a temp file for intermediate JSON output (`mktemp`)
3. Runs the selected checks — each one logs to a file and writes a JSON fragment
4. `mk_json()` uses `jq -s` with a reduce operation to merge all fragments into one clean report
5. `trap clean_up EXIT` removes temp files regardless of how the script exits

## Output

**Terminal** — Color-coded messages using ANSI escape codes:
- 🟢 Green for SUCCESS
- 🔴 Red for ERROR
- 🟡 Yellow for WARN
- 🔵 Cyan for INFO

**Log file** — Written to `/var/log/healthlog/health_check_log.log` (or script directory as fallback)

**JSON report** — Saved as `<timestamp>_report.json` in the script directory

## Concepts Used

- `set -euo pipefail` for strict error handling
- `trap` for cleanup on exit
- Argument parsing with `while/case/shift`
- `jq` for structured JSON output and merging with `reduce`
- `mktemp` for safe temporary files
- `systemctl` for service status checks
- ANSI color codes for readable terminal output
- External config via `source` and `.env` file
- Fallback logic when log paths aren't writable
- `exec` redirection to suppress output in `--json-only` mode

## System util
You can use this as a system utility by adding script directory path to your .bashrc or moving the files to an already added path.make the script executable and give it a short name(vitals).Reload .bashrc and you are good to go.just type vitals --argument.
