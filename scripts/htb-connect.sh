#!/usr/bin/env bash
set -euo pipefail

LAUNCH_DIR="${1:-lab}"
CONFIG="$HOME/.htb/vpn/${LAUNCH_DIR}.ovpn"
CREDS="$HOME/.htb/vpn/creds"

[[ -f "$CONFIG" ]] || {
  echo "❌ Config not found: $CONFIG"
  echo "   Place your .ovpn file in ~/.htb/vpn/"
  exit 1
}

[[ -f "$CREDS" ]] || {
  echo "❌ Credentials not found: $CREDS"
  echo "   Create it with: echo 'username\npassword' > $CREDS"
  exit 1
}

echo "🔌 Connecting to HTB: $LAUNCH_DIR"
sudo openvpn --config "$CONFIG" --auth-user-pass "$CREDS" --verb 3
