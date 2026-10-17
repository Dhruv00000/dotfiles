# #!/bin/bash

# Converting variables exposed by the notification plugin to strings.
CMD="$ET_COMMAND"
EXIT_CODE="$ET_EXIT_CODE"
DURATION="$ET_DURATION_STR"

if [ "$EXIT_CODE" -eq 130 ]; then
    exit 0
fi

case "$CMD" in
    uv|python|python3) # A list of commands that ignore the timing functionality.
        exit 0
        ;;
esac

# Logic for not sending out the notification if the currently focused window is the same as the one that ran the original command.
FOCUSED_PID=$(echo $(niri msg --json focused-window 2>/dev/null) | jq --raw-output '.pid // empty')


CURR_PID=$$
while [ -n "$CURR_PID" ] && [ "$CURR_PID" -gt 1 ]; do
    if [ "$CURR_PID" -eq "$FOCUSED_PID" ]; then
        exit 0
    fi

    PPID_VAL=$((ps -o ppid= -p "$CURR_PID" 2> /dev/null) | tr --delete ' ')
    if [ -z "$PPID_VAL" ] || [ "$PPID_VAL" -eq "$CURR_PID" ]; then # Handling weird process chains.
        break
    fi
    CURR_PID="$PPID_VAL"
done

notify-send --icon "/usr/share/icons/breeze-dark/apps/48/ktimer.svg" "$CMD finished executing" "time taken: $DURATION\nexit code: $EXIT_CODE"