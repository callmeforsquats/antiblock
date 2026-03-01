#!/bin/bash
set -e

echo "Switching ENTER to WireGuard upstream..."

./build-xray.sh enter wg

cd ../builds/enter
docker compose restart xray

echo "Switched to WireGuard upstream"