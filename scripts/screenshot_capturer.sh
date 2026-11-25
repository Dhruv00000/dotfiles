#!/usr/bin/env bash


FILE="$HOME/Pictures/Screenshots/$(date +'%d_%m_%Y__%H_%M_%S').png"

REGION=$(slurp -b "#94949477" -c "#ffffff" -w 2)
if [ -z "$REGION" ]; then
    exit 0
fi

grim -g "$REGION" "$FILE" || exit 1


ACTION=$(notify-send "Screenshot Captured" "Copied to clipboard" --icon="$FILE" --action="edit=󰲶  annotate" --action="lens=  search" --action="scroll=  extend" --action="view=  open" --expire-time=5000 --app-name="Screenshot script")
case "$ACTION" in
    "edit")
        satty --filename "$FILE" --output-filename "$FILE" --disable-notifications
        ;;

    "lens")
        IMAGE_URL=$(curl -s -F "reqtype=fileupload" -F "time=1h" -F "fileToUpload=@$FILE" https://litterbox.catbox.moe/resources/internals/api.php) # TODO: replace this website with file uploading to your own server 

        if [ -n "$IMAGE_URL" ]; then
            zen-browser "https://lens.google.com/uploadbyurl?url=${IMAGE_URL}"
            echo "${IMAGE_URL}"
        else
            notify-send "Google Lens Error" "Failed to upload image for search."
        fi
        ;;

    "scroll")
        notify-send "Scrolling Screenshot" "Select region and start scrolling" --expire-time=2000 --app-name="Screenshot script"
        wayscrollshot --output "$FILE"
        ;;

    "view")
        xdg-open "$FILE"
        ;;
esac


wl-copy < "$FILE"