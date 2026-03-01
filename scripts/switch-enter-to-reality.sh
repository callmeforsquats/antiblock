#!/bin/bash
set -e

echo "Switching ENTER to Reality upstream..."

./build-xray.sh enter reality

cd ../builds/enter
docker compose restart xray

echo "Switched to Reality upstream"