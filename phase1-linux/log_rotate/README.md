# log_rotate.sh

Rotates log files older than 4 days in the specified directory by compressing them into an archive directory and deleting the originals. It supports dry-run mode and handles interruption signals safely.

## Usage

```bash
./log_rotate.sh <directory_path>
```
