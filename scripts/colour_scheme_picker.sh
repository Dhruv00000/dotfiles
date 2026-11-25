#!/usr/bin/env bash


THEME=$(shuf --echo "$HOME/themes"/*.json --head-count=1)
printf "\nApplied $THEME\n" >> "$HOME/system_log.txt"

if [[ ! -f "$THEME" ]]; then
    exit 1
fi

wallust cs "$THEME" --skip-sequences


# Modifying dark reader's database to apply the same colour scheme to websites.
ZEN_SYNC_DATABASE="$HOME/.config/zen/zazj0q2n.test/storage-sync-v2.sqlite"
COLOURS="$HOME/.cache/wallust/darkreader_colors.json"

if [[ -f "$ZEN_SYNC_DATABASE" && -f "$COLOURS" ]] && ! pgrep --exact "zen-bin" >/dev/null 2>&1; then # Modifying zen's database while it is running can cause problems.
    if [[ ! -f "$ZEN_SYNC_DATABASE.bak" ]]; then
        cp "$ZEN_SYNC_DATABASE" "$ZEN_SYNC_DATABASE.bak"
    fi

    CURRENT_DATA=$(sqlite3 "$ZEN_SYNC_DATABASE" "SELECT data FROM storage_sync_data WHERE ext_id='addon@darkreader.org';")
    if [[ -n "$CURRENT_DATA" ]]; then
        UPDATED_DATA=$(jq --compact-output --slurpfile colors "$COLOURS" '
            .syncSettings = true |
            .enabled = true |
            .detectDarkTheme = ($colors[0].detectDarkTheme // false) |
            .theme = (((.theme // {}) | del(.theme, .detectDarkTheme)) + ($colors[0].theme // $colors[0]))
        ' <<< "$CURRENT_DATA")

        if [[ -n "$UPDATED_DATA" ]]; then
            sqlite3 "$ZEN_SYNC_DATABASE" "UPDATE storage_sync_data SET data = '${UPDATED_DATA//\'/\'\'}', sync_change_counter = sync_change_counter + 1 WHERE ext_id='addon@darkreader.org';"
        fi
    fi
fi