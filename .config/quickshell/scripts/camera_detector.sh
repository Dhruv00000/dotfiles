#!/bin/bash

DEVICE="/dev/video0"
STATUS="enabled"
APPS=""

if v4l2-ctl --device "$DEVICE" --get-ctrl=privacy 2>/dev/null | grep --quiet "privacy: 1"; then
    STATUS="disabled"
    exit 0
fi
if fuser "$DEVICE" > /dev/null 2>&1; then
    STATUS="in-use"
    APPS=$(fuser "$DEVICE" 2>/dev/null | tr ' ' '\n' | grep --only-matching '[0-9]\+' | xargs --replace ps --open-tty comm= | sort --unique | paste --serial --delimiters ", " -)
fi

echo "{\"status\": \"$STATUS\", \"apps\": \"$APPS\"}"
exit 0
