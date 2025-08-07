#!/usr/bin/env bash

FILE="$HOME/flake/kvstore"
CLIP_CMD="wl-copy"

entry=$(cut -d'=' -f1 "$FILE" | fzf --layout=reverse) || exit 1
value=$(grep "^$entry=" "$FILE" | cut -d'=' -f2-)

echo -n "$value" | $CLIP_CMD

notify-send "Copied to clipboard" "$entry"
