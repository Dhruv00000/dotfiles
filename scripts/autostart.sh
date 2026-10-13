#!/usr/bin/env bash

echo -e "STARTUP LOG ($(date))\n\n" > "$HOME/system_log.txt" # Clear the previous startup's log entries.

# log_notification() {
#     ACTION=$(notify-send "Niri startup log" "Failed to $1." --wait --icon dialog-error --action="logfile=󱪗 Open log" --expire-time=5000)
#     if [[ -n $ACTION ]]; then
#         xdg-open ~/system_log.txt
#     fi
# }

run_app() {
    local LABEL="$1"
    shift
    (
        if ! "$@" >> "$HOME/system_log.txt" 2>&1; then
            ACTION=$(notify-send "Niri startup log" "Failed to $LABEL." --wait --icon dialog-error --action="logfile=󱪗 Open log" --expire-time=5000)
            if [[ "$ACTION" == "logfile" ]]; then
                xdg-open "$HOME/system_log.txt"
            fi
        fi
    ) &
}

run_app "set colour scheme" "$HOME/scripts/colour_scheme_picker.sh"
run_app "clean trash" "$HOME/scripts/file_cleaner.sh"
run_app "start sunsetr" sunsetr
run_app "start swayidle" swayidle
run_app "start quickshell" quickshell
run_app "start bongocat" bongocat --watch-config
run_app "start hyprpolkitagent" systemctl --user start hyprpolkitagent
run_app "clear evalcache" command rm -rf "$ZSH_EVALCACHE_DIR" # evalcache doesnt update its cache until it is cleared.