#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-}"
[[ -z "$TARGET" ]] && { echo "Usage: htb-scan.sh <ip>"; exit 1; }

echo "🔍 Phase 1: Initial Scan"
nmap -sV -sC "$TARGET"

echo -e "\n🔍 Phase 2: Web Scan (if ports 80/443)"
nmap -p80,443,8080,8443 -sV "$TARGET" | grep -E "^(80|443|8080|8443)"

echo -e "\n🔍 Phase 3: Enumerate"
gobuster dir -u "http://$TARGET" -w "$HTB_WORDLISTS/common.txt" -t 50

echo -e "\n✅ Scan complete. Review: nmap_$TARGET.scan"
