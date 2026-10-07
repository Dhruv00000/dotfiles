#!/usr/bin/env bash
set -o pipefail

(find "$HOME/.local/share/Trash/info/" -mindepth 1 -name "*.trashinfo" -type f -mtime +15 -print0 | while IFS= read -r -d '' infofile; do
    command rm -f "$infofile"
    command rm -rf "$HOME/.local/share/Trash/files/$(basename "$infofile" .trashinfo)"
done >> "$HOME/startup_log.txt" 2>&1) || "$HOME/scripts/startup_log_notifications.sh" "clean trash"

if [ -d "$HOME/Pictures/Screenshots" ]; then
    (find "$HOME/Pictures/Screenshots/" -type f -mtime +10 -print0 | xargs --null --no-run-if-empty rm >> "$HOME/startup_log.txt" 2>&1) || "$HOME/scripts/startup_log_notifications.sh" "clean screenshots"
fi