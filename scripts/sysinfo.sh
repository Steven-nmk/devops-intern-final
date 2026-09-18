#!/bin/sh
set -euo pipefail

echo "=== System Information ==="
echo "User: $(id -un) (UID:$(id -u))"
echo "Hostname: $(hostname)"
echo "Kernel Release: $(uname -r)"
echo "System Date: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"

echo -e "\nDisk Usage:"
df -h /

echo -e "\nMemory Usage:"
free -m

echo -e "\nDocker Daemon Status:"
if command -v docker >/dev/null 2>&1; then
    if docker info >/dev/null 2>&1; then
        echo "Docker is running."
    else
        echo "Docker is installed but not running (or requires root privileges)."
    fi
else
    echo "Docker is not installed."
fi
