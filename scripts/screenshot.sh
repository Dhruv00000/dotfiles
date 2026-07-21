FILE="$HOME/Pictures/Screenshots/$(date +'%d_%m_%Y__%H_%M_%S').png"
grim -g "$(slurp)" "$FILE" || exit 0

wl-copy < "$FILE"

ACTION=$(notify-send "Screenshot Captured" "Copied to clipboard" --icon="$FILE" --action="edit=Annotate" --action="lens=Google Lens" --expire-time=5000)
case "$ACTION" in
    "edit")
        satty --filename "$FILE" --output-filename "$FILE" --disable-notifications
        ;;
    "lens")

        IMAGE_URL=$(curl -s -F "reqtype=fileupload" -F "time=1h" -F "fileToUpload=@$FILE" https://litterbox.catbox.moe/resources/internals/api.php) # First, the file is uploaded online so that google lens has a link to the image

        if [ -n "$IMAGE_URL" ]; then
            zen-browser "https://lens.google.com/uploadbyurl?url=${IMAGE_URL}"
            echo "${IMAGE_URL}"
        else
            notify-send "Google Lens Error" "Failed to upload image for search."
        fi
        ;;
esac
