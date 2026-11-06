#!/usr/bin/env bash
# Restore script for Xiaomi MiTV-AXSO0 (dangal)
# Re-enables all disabled packages, restores the stock launcher, and resets settings.
set -euo pipefail

TV_HOST="${TV_HOST:-192.168.0.158}"
cd "$(dirname "$0")"

echo "Restoring Xiaomi MiTV-AXSO0 on $TV_HOST..."

# 1. Restore debloated packages using repository recovery tool
if [ -f "work/debloat-mitv-axso0.txt" ]; then
  TV_HOST="$TV_HOST" tools/restore.sh work/debloat-mitv-axso0.txt com.google.android.tvlauncher
else
  TV_HOST="$TV_HOST" tools/restore.sh examples/xiaomi-mitv-axso0/debloat.txt com.google.android.tvlauncher
fi

# 2. Reset Private DNS back to default opportunistic mode
echo "Resetting Private DNS to opportunistic..."
TV_HOST="$TV_HOST" tools/venv/bin/python3 tools/tv.py 'settings put global private_dns_mode opportunistic'

# 3. Restore auto-play setting
echo "Resetting set_auto_play to 1..."
TV_HOST="$TV_HOST" tools/venv/bin/python3 tools/tv.py 'settings put global set_auto_play 1'

echo "Restore complete! Rebooting TV..."
TV_HOST="$TV_HOST" tools/venv/bin/python3 tools/tv.py --reboot
