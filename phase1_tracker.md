# 📦 Phase 1 — Linux Power User + Shell Scripting
**Duration**: 3 weeks | **Daily**: 3 hrs | **Goal**: Write real automation scripts

---

## WEEK 1 — Linux Internals

### ✅ Day 1 — The File System
**Concept**: Linux organizes everything as files. Know where things live.

```bash
# Where am I?
pwd

# The entire OS lives under /
ls /

# Key directories to understand today:
ls /etc        # system config files
ls /var/log    # all logs live here
ls /home       # user home directories
ls /tmp        # temporary files (wiped on reboot)
ls /bin        # essential system binaries (commands)
ls /usr/bin    # user-installed binaries

# The virtual filesystems (not real files — kernel data live!)
cat /proc/cpuinfo | head -20    # your CPU, reported by kernel
cat /proc/meminfo | head -10    # your RAM
cat /proc/uptime                # seconds since boot
ls /proc/                       # each number = a running process ID
```

**Understand**: What is the difference between `/bin` and `/usr/bin`? Google it.

**Write in notes.md**:
```
## Day 1 - File System
- /etc = ?
- /var/log = ?
- /proc = ?
- something that surprised me:
```

---

### ✅ Day 2 — File Permissions
**Concept**: Every file has an owner and permission bits. This controls who can do what.

```bash
# Create a test file
mkdir -p ~/devops-journey/phase1-linux
cd ~/devops-journey/phase1-linux
touch test.sh

# Look at permissions
ls -la

# You'll see something like: -rw-r--r--
# Format: [type][owner][group][others]
# r=read(4)  w=write(2)  x=execute(1)

# Change permissions using numbers
chmod 755 test.sh    # owner=rwx(7), group=rx(5), others=rx(5)
ls -la test.sh

chmod 644 test.sh    # owner=rw(6), group=r(4), others=r(4)
ls -la test.sh

chmod 000 test.sh    # no permissions for anyone
cat test.sh          # THIS FAILS — understand why!
chmod 644 test.sh    # restore it

# Who owns files?
ls -la /etc/passwd   # owned by root
whoami               # your current user

# Change owner (needs sudo — just read the syntax for now)
# sudo chown username:groupname filename
```

**Challenge**: What does `chmod 777` mean? Why is it dangerous?

---

### ✅ Day 3 — Process Management
**Concept**: Everything running on your system is a process. You control them.

```bash
# See all running processes
ps aux

# ps output columns: USER PID %CPU %MEM ... COMMAND
# PID = Process ID (unique number for each process)

# Filter processes
ps aux | grep bash       # find bash processes
ps aux | grep firefox    # find firefox (if running)

# Live process viewer
top                      # press q to quit, k to kill a process

# Start a background process
sleep 200 &              # & sends it to background
ps aux | grep sleep      # find it — note the PID

# Kill it
kill <PID>               # replace <PID> with the actual number
# OR
kill %1                  # kill last backgrounded job

# Process signals
kill -l                  # list all signals
kill -9 <PID>            # SIGKILL — force kill, no cleanup
kill -15 <PID>           # SIGTERM — polite kill (default)

# See process tree
ps aux --forest | head -30

# Parent/child relationships
echo $$                  # current shell's PID
```

---

### ✅ Day 4 — User & Group Management
**Concept**: Linux is multi-user. Every process runs as a user.

```bash
# Who am I?
whoami
id                       # shows UID, GID, and all groups you belong to

# All users on the system
cat /etc/passwd          # format: username:x:UID:GID:comment:home:shell

# All groups
cat /etc/group

# Switch user (if you have another account)
su - username

# Your current groups
groups

# See login history
last | head -10

# See failed login attempts
lastb | head -10         # may need sudo

# The root user
# UID 0 = root = god mode. Never run as root unless necessary.
```

---

### ✅ Day 5 — Networking Basics
**Concept**: Understand how your machine talks to the network.

```bash
# Your IP addresses
ip addr show
ip addr show | grep "inet "    # just IPv4 addresses

# Network interfaces
ip link show

# Routing table (how traffic flows)
ip route show

# Is a host reachable?
ping google.com -c 4           # -c 4 = send 4 packets then stop

# What's on your network ports?
ss -tulnp                      # listening ports (better than netstat)
# t=tcp u=udp l=listening n=numeric p=process

# DNS lookup
curl -s https://ifconfig.me    # your public IP
nslookup google.com            # DNS resolution

# Make an HTTP request
curl https://httpbin.org/get   # returns your request info as JSON
curl -I https://google.com     # just the HTTP headers
```

---

### ✅ Day 6 — Logs & System Info
**Concept**: Logs tell you everything that happened on a system. DevOps = reading logs.

```bash
# System logs
ls /var/log/
cat /var/log/syslog | tail -20        # last 20 lines
cat /var/log/auth.log | tail -20      # login/auth events

# Follow a log live (like tail -f)
tail -f /var/log/syslog               # press Ctrl+C to stop

# System journal (modern Ubuntu)
journalctl | tail -20                 # recent logs
journalctl -u ssh                     # logs for a specific service
journalctl --since "1 hour ago"       # last hour of logs

# System hardware info
lscpu                                 # CPU details
free -h                               # RAM (human readable)
df -h                                 # disk usage
lsblk                                 # block devices (disks)
uname -r                              # kernel version
```

---

### ✅ Day 7 — Week 1 Review + Mini-Project
**Mini-Project**: Disk usage monitor script

Create `~/devops-journey/phase1-linux/disk_monitor.sh`:

```bash
#!/bin/bash
# disk_monitor.sh - Check disk usage and warn if > 80%

THRESHOLD=80
LOGFILE="$HOME/devops-journey/notes/disk_monitor.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$DATE] Running disk check..." | tee -a "$LOGFILE"

df -h | grep -vE '^Filesystem|tmpfs|udev' | while read -r line; do
    USAGE=$(echo "$line" | awk '{print $5}' | sed 's/%//')
    MOUNT=$(echo "$line" | awk '{print $6}')

    if [ "$USAGE" -gt "$THRESHOLD" ]; then
        echo "[$DATE] ⚠️  WARNING: $MOUNT is at ${USAGE}% usage!" | tee -a "$LOGFILE"
    else
        echo "[$DATE] ✅  OK: $MOUNT is at ${USAGE}% usage" | tee -a "$LOGFILE"
    fi
done
```

Run it:
```bash
chmod +x ~/devops-journey/phase1-linux/disk_monitor.sh
bash ~/devops-journey/phase1-linux/disk_monitor.sh
```

---

## WEEK 2 — Shell Scripting

### ✅ Day 8 — Variables & User Input
```bash
# Variables
NAME="devops"
echo $NAME
echo "Hello, $NAME"
echo "Hello, ${NAME}!"     # use {} for clarity

# Numbers
NUM=10
echo $((NUM + 5))
echo $((NUM * 3))

# Command output into variable
CURRENT_DATE=$(date)
echo "Today is: $CURRENT_DATE"

FILES=$(ls ~/devops-journey/)
echo "$FILES"

# Read user input
read -p "Enter your name: " USERNAME
echo "Hello, $USERNAME!"

# Special variables
echo "Script name: $0"
echo "First argument: $1"
echo "All arguments: $@"
echo "Number of arguments: $#"
echo "Last exit code: $?"
```

---

### ✅ Day 9 — Conditionals
```bash
# Basic if
if [ condition ]; then
    # do something
fi

# Real examples
FILE="test.txt"
touch $FILE

if [ -f "$FILE" ]; then
    echo "File exists"
fi

if [ ! -f "missing.txt" ]; then
    echo "missing.txt does not exist"
fi

# Compare numbers
NUM=15
if [ $NUM -gt 10 ]; then
    echo "$NUM is greater than 10"
elif [ $NUM -eq 10 ]; then
    echo "Equal to 10"
else
    echo "Less than 10"
fi

# String comparison
NAME="ubuntu"
if [ "$NAME" = "ubuntu" ]; then
    echo "Running on Ubuntu"
fi

# Check if command exists
if command -v git &>/dev/null; then
    echo "git is installed: $(git --version)"
else
    echo "git is not installed"
fi
```

---

### ✅ Day 10 — Loops
```bash
# For loop over list
for COLOR in red green blue; do
    echo "Color: $COLOR"
done

# For loop with range
for i in {1..5}; do
    echo "Number: $i"
done

# Loop over files
for FILE in ~/devops-journey/phase1-linux/*; do
    echo "Found file: $FILE"
done

# While loop
COUNT=1
while [ $COUNT -le 5 ]; do
    echo "Count: $COUNT"
    COUNT=$((COUNT + 1))
done

# Infinite loop (use with care!)
# while true; do
#     echo "running..."
#     sleep 2
# done

# Loop through command output
ps aux | tail -5 | while read -r line; do
    echo "Process: $line"
done
```

---

### ✅ Day 11 — Functions
```bash
# Define a function
greet() {
    echo "Hello, $1!"
}

# Call it
greet "DevOps"
greet "World"

# Function with return value
is_even() {
    if [ $(($1 % 2)) -eq 0 ]; then
        return 0    # 0 = success/true in bash
    else
        return 1    # non-zero = failure/false
    fi
}

is_even 4
if [ $? -eq 0 ]; then echo "4 is even"; fi

is_even 7
if [ $? -eq 0 ]; then echo "7 is even"; else echo "7 is odd"; fi

# Practical function
check_service() {
    SERVICE=$1
    if systemctl is-active --quiet "$SERVICE" 2>/dev/null; then
        echo "✅ $SERVICE is running"
    else
        echo "❌ $SERVICE is NOT running"
    fi
}

check_service ssh
check_service nginx
```

---

### ✅ Day 12 — Text Processing: grep, awk, sed
```bash
# grep — search for patterns
grep "root" /etc/passwd              # lines containing "root"
grep -i "error" /var/log/syslog      # case-insensitive
grep -n "error" /var/log/syslog      # with line numbers
grep -v "comment" file.txt           # lines NOT matching
grep -r "TODO" ~/devops-journey/     # recursive search

# awk — process columns of text
ps aux | awk '{print $1, $2, $11}'   # print user, PID, command
df -h | awk '{print $1, $5}'         # filesystem and usage %
echo "hello world" | awk '{print $2}' # print second word

# awk with condition
ps aux | awk '$3 > 1.0 {print $1, $2, $3, $11}'  # CPU > 1%

# sed — stream editor (find and replace)
echo "Hello World" | sed 's/World/DevOps/'    # replace
echo "foo bar foo" | sed 's/foo/baz/g'        # replace all (g flag)
sed -n '1,5p' /etc/passwd                     # print lines 1-5
cat /etc/passwd | sed '/^#/d'                 # delete comment lines
```

---

### ✅ Day 13 — Error Handling & Robust Scripts
```bash
# Always start scripts with these
#!/bin/bash
set -e          # exit immediately on any error
set -u          # treat unset variables as errors
set -o pipefail # catch errors in pipes

# Trap — run cleanup on exit or error
cleanup() {
    echo "Cleaning up..."
    rm -f /tmp/tempfile.$$
}
trap cleanup EXIT   # runs cleanup() when script exits (any reason)

# Check exit codes
mkdir /some/path 2>/dev/null
if [ $? -ne 0 ]; then
    echo "ERROR: Could not create directory"
    exit 1
fi

# Or use || shorthand
mkdir /some/path || { echo "ERROR: failed"; exit 1; }

# Redirect errors
command 2>/dev/null          # suppress errors
command 2>&1 | tee log.txt   # log both stdout and stderr
```

---

### ✅ Day 14 — Week 2 Mini-Project: Log Rotation Script

Create `~/devops-journey/phase1-linux/log_rotate.sh`:
```bash
#!/bin/bash
set -euo pipefail

LOG_DIR="$HOME/devops-journey/notes"
ARCHIVE_DIR="$HOME/devops-journey/notes/archive"
DAYS_OLD=7

mkdir -p "$ARCHIVE_DIR"

echo "🔄 Starting log rotation..."
echo "Looking for logs older than $DAYS_OLD days in $LOG_DIR"

find "$LOG_DIR" -maxdepth 1 -name "*.log" -mtime +$DAYS_OLD | while read -r logfile; do
    BASENAME=$(basename "$logfile")
    ARCHIVED="$ARCHIVE_DIR/${BASENAME%.log}_$(date +%Y%m%d).log.gz"
    echo "  Archiving: $BASENAME → $ARCHIVED"
    gzip -c "$logfile" > "$ARCHIVED"
    rm "$logfile"
done

echo "✅ Log rotation complete."
ls -lh "$ARCHIVE_DIR" 2>/dev/null || echo "No archives yet."
```

---

## WEEK 3 — Advanced Shell + Automation

### ✅ Day 15 — find & xargs
```bash
# find — search for files
find ~ -name "*.sh"                  # all shell scripts in home
find ~ -name "*.log" -mtime -1       # logs modified in last 1 day
find /tmp -size +1M                  # files bigger than 1MB
find ~ -type d -name "phase*"        # directories named phase*
find ~ -perm 777                     # files with 777 permissions (dangerous!)

# xargs — feed find output into other commands
find ~/devops-journey -name "*.sh" | xargs ls -la
find ~/devops-journey -name "*.log" | xargs wc -l    # line count each log
find /tmp -name "*.tmp" | xargs rm -f                # delete all .tmp files

# exec alternative (safer)
find ~/devops-journey -name "*.sh" -exec chmod +x {} \;
```

---

### ✅ Day 16 — Cron Jobs
```bash
# Cron = schedule scripts to run automatically
# Syntax: minute hour day month weekday command
# *      *    *   *     *

# Edit your crontab
crontab -e      # opens editor

# Examples to add:
# Run disk monitor every day at 8am
0 8 * * * /home/umesh-dulara/devops-journey/phase1-linux/disk_monitor.sh

# Run every 5 minutes
*/5 * * * * echo "ping" >> /tmp/cron_test.log

# Run on system startup (@reboot)
@reboot /path/to/startup_script.sh

# View your crontab
crontab -l

# Remove crontab
# crontab -r
```

---

### ✅ Day 17 — SSH & Remote Access
```bash
# Generate SSH key pair (if you don't have one)
ls ~/.ssh/                          # check if keys exist
ssh-keygen -t ed25519 -C "your-email@example.com"
ls ~/.ssh/                          # id_ed25519 (private) + id_ed25519.pub (public)

# NEVER share your private key. Only share .pub

# Copy public key to a server
# ssh-copy-id user@server-ip

# SSH into a server
# ssh user@server-ip
# ssh -i ~/.ssh/id_ed25519 user@server-ip   # specify key

# Copy files over SSH
# scp localfile.txt user@server:/remote/path/
# scp -r localfolder/ user@server:/remote/path/

# Sync files efficiently
# rsync -avz localfolder/ user@server:/remote/folder/

# SSH config file (saves typing)
cat ~/.ssh/config 2>/dev/null || echo "No config yet"
# Create ~/.ssh/config:
# Host myserver
#     HostName 192.168.1.100
#     User ubuntu
#     IdentityFile ~/.ssh/id_ed25519
# Then just: ssh myserver
```

---

### ✅ Day 18 — jq & JSON Processing
```bash
# jq processes JSON in shell scripts
# DevOps APIs return JSON — you NEED this

# Basic usage
echo '{"name":"ubuntu","version":"24.04"}' | jq .
echo '{"name":"ubuntu","version":"24.04"}' | jq '.name'
echo '{"name":"ubuntu","version":"24.04"}' | jq '.version'

# Real world: query an API
curl -s https://api.github.com/repos/torvalds/linux | jq '.'
curl -s https://api.github.com/repos/torvalds/linux | jq '.stargazers_count'
curl -s https://api.github.com/repos/torvalds/linux | jq '.name, .language, .forks'

# Arrays
echo '[1,2,3,4,5]' | jq '.[]'         # iterate array
echo '[1,2,3,4,5]' | jq '.[2]'        # index into array
echo '[1,2,3,4,5]' | jq 'length'      # length of array

# Filter and transform
curl -s https://api.github.com/users/torvalds/repos | jq '.[].name'
```

---

### ✅ Day 19 — Environment Variables
```bash
# View all environment variables
env
printenv

# View specific variable
echo $HOME
echo $PATH
echo $USER
echo $SHELL

# Set a variable (only in current session)
export MY_VAR="hello"
echo $MY_VAR

# Make it permanent — add to ~/.bashrc
echo 'export MY_VAR="hello"' >> ~/.bashrc
source ~/.bashrc              # reload without restarting terminal

# PATH — where bash looks for commands
echo $PATH | tr ':' '\n'      # show each path on its own line

# Add to PATH
export PATH="$HOME/bin:$PATH"

# In scripts — always use full paths or set your own PATH
```

---

### ✅ Day 20 & 21 — Week 3 Mini-Project: System Health Check Script

Create `~/devops-journey/phase1-linux/health_check.sh`:

```bash
#!/bin/bash
set -euo pipefail

# =============================================
# System Health Check Script
# =============================================
LOGDIR="$HOME/devops-journey/notes"
LOGFILE="$LOGDIR/health_$(date +%Y%m%d_%H%M%S).log"
mkdir -p "$LOGDIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() { echo -e "$1" | tee -a "$LOGFILE"; }

log "============================================"
log "  System Health Check — $(date)"
log "  Host: $(hostname)"
log "============================================"

# CPU Usage
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
log "\n📊 CPU Usage: ${CPU}%"

# Memory
TOTAL_MEM=$(free -h | awk '/^Mem:/{print $2}')
USED_MEM=$(free -h | awk '/^Mem:/{print $3}')
MEM_PCT=$(free | awk '/^Mem:/{printf "%.0f", $3/$2*100}')
if [ "$MEM_PCT" -gt 80 ]; then
    log "${RED}⚠️  Memory: ${USED_MEM} / ${TOTAL_MEM} (${MEM_PCT}%) — HIGH!${NC}"
else
    log "${GREEN}✅ Memory: ${USED_MEM} / ${TOTAL_MEM} (${MEM_PCT}%)${NC}"
fi

# Disk Usage
log "\n💾 Disk Usage:"
df -h | grep -vE '^Filesystem|tmpfs|udev' | while read -r line; do
    USAGE=$(echo "$line" | awk '{print $5}' | sed 's/%//')
    MOUNT=$(echo "$line" | awk '{print $6}')
    if [ "$USAGE" -gt 80 ]; then
        log "  ${RED}⚠️  $MOUNT: ${USAGE}%${NC}"
    else
        log "  ${GREEN}✅ $MOUNT: ${USAGE}%${NC}"
    fi
done

# Top 5 CPU processes
log "\n🔝 Top 5 Processes by CPU:"
ps aux --sort=-%cpu | awk 'NR>1 && NR<=6 {printf "  %-20s CPU: %s%%\n", $11, $3}' | tee -a "$LOGFILE"

# Network connectivity
log "\n🌐 Network:"
if ping -c 1 8.8.8.8 &>/dev/null; then
    log "  ${GREEN}✅ Internet: Connected${NC}"
else
    log "  ${RED}❌ Internet: No connectivity${NC}"
fi

log "\n📝 Full log saved to: $LOGFILE"
log "============================================"
```

Run it:
```bash
chmod +x ~/devops-journey/phase1-linux/health_check.sh
bash ~/devops-journey/phase1-linux/health_check.sh
```

Schedule it with cron to run every morning:
```bash
crontab -e
# Add: 0 8 * * * /home/umesh-dulara/devops-journey/phase1-linux/health_check.sh
```

---

## 🏁 Phase 1 Complete — What You Now Know

- [ ] Linux file system hierarchy
- [ ] File permissions (`chmod`, `chown`)
- [ ] Process management (`ps`, `top`, `kill`)
- [ ] User & group management
- [ ] Networking basics (`ip`, `ss`, `curl`, `ping`)
- [ ] Reading system logs (`journalctl`, `tail -f`)
- [ ] Shell scripting: variables, conditionals, loops, functions
- [ ] Text processing: `grep`, `awk`, `sed`, `jq`
- [ ] Error handling in scripts (`set -e`, `trap`)
- [ ] Cron jobs
- [ ] SSH basics
- [ ] 3 real scripts in your portfolio

**Next**: Phase 2 — Docker & Containers 🐳
