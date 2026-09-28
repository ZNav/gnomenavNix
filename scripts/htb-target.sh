#!/usr/bin/env bash
set -euo pipefail

IP="$1"
DOMAIN="${2:-$(basename ${PWD##*/}).htb}"

[[ -n "$IP" ]] || { echo "Usage: htb-target.sh <ip> [domain]"; exit 1; }

echo "$IP    $DOMAIN" | sudo tee -a /etc/hosts > /dev/null
echo "✅ Added: $DOMAIN → $IP"
