#!/bin/bash
set -e

ROLE=$1        # enter | exit
PROFILE=$2     # wg | reality (только для enter)

BASE="../core/xray-base.json"
DNS="../core/dns.json"

OUT_DIR="../builds/$ROLE/generated"
OUT_FILE="$OUT_DIR/config.json"

mkdir -p "$OUT_DIR"

echo "Building Xray config for role: $ROLE"

# 1️⃣ Загружаем базу + DNS
CONFIG=$(jq -s '.[0] * .[1]' "$BASE" "$DNS")

# 2️⃣ Inbounds
if [ "$ROLE" == "enter" ]; then
  INBOUNDS=$(jq -s '.' \
    ../modules/inbounds/enter-reality-primary.json \
    ../modules/inbounds/enter-reality-alt.json)
else
  INBOUNDS=$(jq -s '.' \
    ../modules/inbounds/exit-reality-from-enter.json)
fi

CONFIG=$(echo "$CONFIG" | jq --argjson inb "$INBOUNDS" '.inbounds = $inb')

# 3️⃣ Outbounds + Routing
if [ "$ROLE" == "enter" ]; then

  if [ "$PROFILE" == "wg" ]; then
    OUTS=$(jq -s '.' ../modules/outbounds/enter-wireguard.json)
    ROUTE="../modules/routing/enter-wg-profile.json"
    echo "Using WireGuard upstream"
  else
    OUTS=$(jq -s '.' ../modules/outbounds/enter-reality-upstream.json)
    ROUTE="../modules/routing/enter-reality-profile.json"
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