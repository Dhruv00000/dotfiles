#!/bin/bash

DEVICE="/dev/video0"
STATUS="enabled"
APPS=""

if v4l2-ctl -d "$DEVICE" --get-ctrl=privacy 2>/dev/null | grep -q "privacy: 1"; then
    STATUS="disabled"
    exit 0
fi
if fuser "$DEVICE" > /dev/null 2>&1; then
    STATUS="in-use"
    APPS=$(fuser "$DEVICE" 2>/dev/null | tr ' ' '\n' | grep -o '[0-9]\+' | xargs -r ps -o comm= | sort -u | paste -sd ", " -)
fi

echo "{\"status\": \"$STATUS\", \"apps\": \"$APPS\"}"
exit 0
