#!/bin/bash

WINDOW_ID=$(niri msg --json windows | jq --raw-output ".[] | select(.app_id == \"$1\") | .id" | head -n 1)
CMD="${2:-$1}"

if [ -n "$WINDOW_ID" ]; then
    niri msg action focus-window --id "$WINDOW_ID"
else
    $CMD &
fi