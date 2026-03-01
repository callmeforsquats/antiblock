#!/bin/bash
set -e

ROLE=$1        # entry | exit
PROFILE=$2     # wg | reality (только для entry)

BASE="../core/xray-base.json"
DNS="../core/dns.json"

OUT_DIR="../builds/$ROLE/generated"
OUT_FILE="$OUT_DIR/config.json"

mkdir -p "$OUT_DIR"

echo "Building Xray config for role: $ROLE"

# 1️⃣ Загружаем базу + DNS
CONFIG=$(jq -s '.[0] * .[1]' "$BASE" "$DNS")

# 2️⃣ Inbounds
if [ "$ROLE" == "entry" ]; then
  INBOUNDS=$(jq -s '.' \
    ../modules/inbounds/entry-reality-1.json \
    ../modules/inbounds/entry-reality-2.json)
else
  INBOUNDS=$(jq -s '.' \
    ../modules/inbounds/exit-reality-from-entry.json)
fi

CONFIG=$(echo "$CONFIG" | jq --argjson inb "$INBOUNDS" '.inbounds = $inb')

# 3️⃣ Outbounds + Routing
if [ "$ROLE" == "entry" ]; then

  if [ "$PROFILE" == "wg" ]; then
    OUTS=$(jq -s '.' ../modules/outbounds/entry-wireguard.json)
    ROUTE="../modules/routing/entry-wg-profile.json"
    echo "Using WireGuard upstream"
  else
    OUTS=$(jq -s '.' ../modules/outbounds/entry-reality.json)
    ROUTE="../modules/routing/entry-reality-profile.json"
    echo "Using Reality upstream"
  fi

else
  OUTS=$(jq -s '.' ../modules/outbounds/exit-direct.json)
  ROUTE="../modules/routing/exit-profile.json"
fi

CONFIG=$(echo "$CONFIG" | jq --argjson outs "$OUTS" '.outbounds = $outs')

# 4️⃣ Routing merge
CONFIG=$(echo "$CONFIG" | jq -s '.[0] * .[1]' - "$ROUTE")

# 5️⃣ Запись
echo "$CONFIG" > "$OUT_FILE"

echo "Config written to $OUT_FILE"