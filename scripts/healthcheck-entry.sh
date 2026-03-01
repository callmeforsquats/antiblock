#!/bin/bash

echo "Checking ENTRY services..."

docker ps | grep xray-entry > /dev/null
if [ $? -ne 0 ]; then
  echo "Xray not running!"
  exit 1
fi

docker ps | grep wg-entry > /dev/null
if [ $? -ne 0 ]; then
  echo "WireGuard not running!"
  exit 1
fi

echo "ENTRY OK"