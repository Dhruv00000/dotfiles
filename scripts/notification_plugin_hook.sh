#!/bin/zsh


CMD="$ET_COMMAND"
EXIT_CODE="$ET_EXIT_CODE"
DURATION="$ET_DURATION_STR"


case "$CMD" in
    ageagboa|geageasgsa) # A placeholder for a list of commands that ignore the timing functionality.
        exit 0
        ;;
esac


# Code for not sending out the notification if the currently focused window is the same as the one that ran the original command.
FOCUSED_PID=$(niri msg --json focused-window 2>/dev/null | jq --raw-output '.pid // empty')
CURRENT_PID="${1:-$$}"
if [ -n "$FOCUSED_PID" ]; then

    while [ -n "$CURRENT_PID" ] && [ "$CURRENT_PID" -gt 1 ]; do
        if [ "$CURRENT_PID" -eq "$FOCUSED_PID" ]; then
            exit 0
        fi

        PARENT_PID=$(ps -o ppid= -p "$CURRENT_PID" 2> /dev/null | tr --delete ' ')
        if [ -z "$PARENT_PID" ] || [ "$PARENT_PID" -eq "$CURRENT_PID" ]; then # Handling weird process chains.
            break
        fi
        CURRENT_PID="$PARENT_PID"
    done

fi


notify-send --icon "/usr/share/icons/breeze-dark/apps/48/ktimer.svg" "$CMD finished executing" $'time taken: '"$DURATION"$'\nexit code: '"$EXIT_CODE" --app-name "zsh"