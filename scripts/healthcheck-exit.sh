#!/bin/bash

echo "Checking EXIT services..."

docker ps | grep xray-exit > /dev/null
if [ $? -ne 0 ]; then
  echo "Xray not running!"
  exit 1
fi

docker ps | grep wg-exit > /dev/null
if [ $? -ne 0 ]; then
  echo "WireGuard not running!"
  exit 1
fi

echo "EXIT OK"