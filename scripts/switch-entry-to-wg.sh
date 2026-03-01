#!/bin/bash
set -e

echo "Switching ENTRY to WireGuard upstream..."

./build-xray.sh entry wg

cd ../builds/entry
docker compose restart xray

echo "Switched to WireGuard upstream"