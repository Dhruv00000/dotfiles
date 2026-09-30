#!/bin/bash

CMD="$ET_COMMAND"
EXIT_CODE="$ET_EXIT_CODE"
DURATION="$ET_DURATION_STR"

if [ "$EXIT_CODE" -eq 130 ]; then
    exit 0
fi

case "$CMD" in
    man|nano|uv|python|python3|btop)
        exit 0
        ;;
esac

notify-send -i "/usr/share/icons/breeze-dark/apps/48/ktimer.svg" \
    "$CMD finished executing" \
    "time taken: $DURATION\nexit code: $EXIT_CODE"