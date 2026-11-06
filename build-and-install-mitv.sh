#!/usr/bin/env bash
# Build and install script for Xiaomi MiTV-AXSO0 (dangal)
# Builds the launcher APK and installs it as the default Home screen.
set -euo pipefail

TV_HOST="${TV_HOST:-192.168.0.158}"
cd "$(dirname "$0")/launcher"

echo "Building and installing launcher on $TV_HOST..."
TV_HOST="$TV_HOST" ./build-and-install.sh
