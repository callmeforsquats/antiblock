#!/bin/bash
set -e

ROLE=$1  # entry | exit

TEMPLATE="../builds/$ROLE/wg0.conf.template"
OUTPUT="../builds/$ROLE/wg0.conf"
ENV_FILE="../builds/$ROLE/.env"

if [ ! -f "$ENV_FILE" ]; then
  echo ".env not found for $ROLE"
  exit 1
fi

source "$ENV_FILE"

echo "Building WireGuard config for $ROLE"

cp "$TEMPLATE" "$OUTPUT"

# Замены
sed -i "s/{{ENTER_WG_PRIVATE_KEY}}/$ENTRY_WG_PRIVATE_KEY/g" "$OUTPUT"
sed -i "s/{{EXIT_WG_PRIVATE_KEY}}/$EXIT_WG_PRIVATE_KEY/g" "$OUTPUT"
sed -i "s/{{ENTER_WG_PUBLIC_KEY}}/$ENTRY_WG_PUBLIC_KEY/g" "$OUTPUT"
sed -i "s/{{EXIT_WG_PUBLIC_KEY}}/$EXIT_WG_PUBLIC_KEY/g" "$OUTPUT"
sed -i "s/{{EXIT_PUBLIC_IP}}/$EXIT_PUBLIC_IP/g" "$OUTPUT"

echo "WireGuard config written to $OUTPUT"