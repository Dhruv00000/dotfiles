# #!/bin/bash

# LOCAL_FOLDER="$HOME/.config"
# MEGA_DEST="/CloudConfig"

# inotifywait -q -r -m -e close_write,create,moved_to "$LOCAL_FOLDER" |
# while read -r directory events filename; do
#     # Skip hidden/temporary files to prevent spamming
#     if [[ "$filename" == .* ]]; then continue; fi

#     echo "Change detected: $directory$filename. Pushing to MEGA..."

#     mega-put -c "$LOCAL_FOLDER" "$MEGA_DEST"
# done

# #!/bin/bash
# trap 'kill $(jobs -p) 2>/dev/null' EXIT

# watch_folder() {
#     local local_dir="$1"
#     local remote_dir="$2"

#     echo "Starting watcher for folder: $local_dir -> MEGA:$remote_dir"

#     inotifywait -q -r -m -e close_write,create,moved_to "$local_dir" |
#     while read -r directory events filename; do

#         [[ "$filename" == *.tmp || "$filename" == *~ ]] && continue

#         echo "[Folder Change] $directory$filename -> Updating $remote_dir"
#         mega-put -c "$local_dir" "$remote_dir"
#     done
# }

# watch_file() {
#     local local_file="$1"
#     local remote_dir="$2"

#     local parent_dir=$(dirname "$local_file")
#     local base_name=$(basename "$local_file")

#     echo "Starting watcher for file: $local_file -> MEGA:$remote_dir"

#     inotifywait -q -m -e close_write,moved_to "$parent_dir" |
#     while read -r directory events filename; do
#         if [[ "$filename" == "$base_name" ]]; then
#             echo "[File Change] $local_file -> Updating $remote_dir"
#             mega-put -c "$local_file" "$remote_dir"
#         fi
#     done
# }

#!/bin/bash

trap 'kill $(jobs -p) 2>/dev/null' EXIT

watch_folder() {

    local local_dir="${1%/}"
    local remote_dir="${2%/}"

    echo "Starting watcher for folder: $local_dir -> MEGA:$remote_dir"

    inotifywait -q -r -m --exclude "zen/|google-chrome/|chromium/|BraveSoftware/" -e close_write,create,moved_to,delete "$local_dir" |
    while read -r directory events filename; do
        [[ "$filename" == *.tmp || "$filename" == *~ ]] && continue

        local full_path="$directory$filename"
        local relative_path="${full_path#$local_dir/}"

        if [[ "$events" =~ "DELETE" ]]; then
            echo "[Deleted] $full_path -> Removing from MEGA:$remote_dir/$relative_path"
            mega-rm "$remote_dir/$relative_path"

        else
            echo "[Modified] $full_path -> Updating $remote_dir"
            mega-put -c "$local_dir" "$remote_dir"
        fi
    done
}

watch_file() {
    local local_file="$1"
    local remote_dir="${2%/}"

    local parent_dir=$(dirname "$local_file")
    local base_name=$(basename "$local_file")

    echo "Starting watcher for file: $local_file -> MEGA:$remote_dir"

    inotifywait -q -m -e close_write,moved_to,delete "$parent_dir" |
    while read -r directory events filename; do
        if [[ "$filename" == "$base_name" ]]; then
            if [[ "$events" =~ "DELETE" ]]; then
                echo "[Deleted] $local_file -> Removing from MEGA:$remote_dir/$base_name"
                mega-rm "$remote_dir/$base_name"
            else
                echo "[Modified] $local_file -> Updating $remote_dir"
                mega-put -c "$local_file" "$remote_dir"
            fi
        fi
    done
}

watch_folder "$HOME/Projects" "/CloudProjects" &
watch_folder "$HOME/.config/autostart" "/CloudConfig" &
watch_folder "$HOME/.config/environment.d/" "/CloudConfig" &
watch_folder "$HOME/.config/kitty" "/CloudConfig" &
watch_folder "$HOME/.config/Kvantum" "/CloudConfig" &
watch_folder "$HOME/.config/matugen" "/CloudConfig" &
watch_folder "$HOME/.config/niri" "/CloudConfig" &
watch_folder "$HOME/.config/qt5ct" "/CloudConfig" &
watch_folder "$HOME/.config/qt6ct" "/CloudConfig" &
watch_folder "$HOME/.config/quickshell" "/CloudConfig" &
watch_folder "$HOME/.config/rofi" "/CloudConfig" &
watch_folder "$HOME/.config/starship" "/CloudConfig" &
watch_folder "$HOME/.config/swayidle" "/CloudConfig" &
watch_folder "$HOME/.config/waypaper" "/CloudConfig" &
watch_folder "$HOME/.config/zed" "/CloudConfig" &

watch_folder "$HOME/.local/share/PrismLauncher/instances" "/CloudMinecraft" &

watch_folder "$HOME/scripts" "/CloudScripts" &

watch_folder "$HOME/wallpapers" "CloudWallpapers" &

watch_file "$HOME/.zshrc" "/CloudZshrc" &
watch_file "/etc/tlp.conf" "/CloudTlpconf" &


wait
