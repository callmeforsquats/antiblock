#!/bin/bash
set -e

echo "Switching ENTRY to Reality upstream..."

./build-xray.sh entry
 reality

cd ../builds/entry

docker compose restart xray

echo "Switched to Reality upstream"