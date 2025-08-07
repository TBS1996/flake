#!/usr/bin/env bash

FILE="$HOME/flake/kvstore"
CLIP_CMD="wl-copy"

entry=$(fzf < "$FILE") || exit 1
value=$(echo "$entry" | cut -d'=' -f2-)

echo -n "$value" | $CLIP_CMD

notify-send "Copied to clipboard" "$entry"

