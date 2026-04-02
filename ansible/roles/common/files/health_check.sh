#!/bin/bash
# K3s node health check
set -e

SERVICE="k3s"

if systemctl is-active --quiet $SERVICE; then
    echo "✓ $SERVICE is running"
else
    echo "✗ $SERVICE is down" >&2
    exit 1
fi

echo "✓ Node: $(hostname)"
echo "✓ IP: $(hostname -I | awk '{print $1}')"
echo "✓ Uptime: $(uptime -p)"