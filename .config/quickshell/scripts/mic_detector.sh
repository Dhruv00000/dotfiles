#!/bin/bash

MUTE_STATUS=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)

if [[ "$MUTE_STATUS" == *"[MUTED]"* ]]; then
    STATUS="disabled"
    APPS=""
else
    DEFAULT_SOURCE=$(pactl get-default-source)
    STATE=$(pactl list sources | grep -B 2 "Name: $DEFAULT_SOURCE" | grep "State:" | head -n 1 | awk '{print $2}')

    if [ "$STATE" == "RUNNING" ]; then
        STATUS="in-use"

        APPS=$(pactl list source-outputs | grep "application.name =" | cut -d '"' -f 2 | sort -u | paste -sd ", " -)
    else
        STATUS="enabled"
        APPS=""
    fi
fi

echo "{\"status\": \"$STATUS\", \"apps\": \"$APPS\"}"
