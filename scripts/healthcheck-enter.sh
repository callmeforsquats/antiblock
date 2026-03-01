#!/bin/bash

echo "Checking ENTER services..."

docker ps | grep xray-enter > /dev/null
if [ $? -ne 0 ]; then
  echo "Xray not running!"
  exit 1
fi

docker ps | grep wg-enter > /dev/null
if [ $? -ne 0 ]; then
  echo "WireGuard not running!"
  exit 1
fi

echo "ENTER OK"