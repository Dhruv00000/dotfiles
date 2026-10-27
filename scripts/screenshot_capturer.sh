#         IMAGE_URL=$(curl -s -F "reqtype=fileupload" -F "time=1h" -F "fileToUpload=@$FILE" https://litterbox.catbox.moe/resources/internals/api.php) # First, the file is uploaded online so that google lens has a link to the image
#         # TODO: replace this website with file uploading to your own server


FILE="$HOME/Pictures/Screenshots/$(date +'%d_%m_%Y__%H_%M_%S').png"

TMP_FILE=$(mktemp --suffix=.png)

# Clean up temporary file and any active swayimg process on exit
trap 'rm -f "$TMP_FILE"; [ -n "$SWAY_PID" ] && kill "$SWAY_PID" 2>/dev/null' EXIT

# 1. Capture the initial full screen state
grim "$TMP_FILE" || exit 0

# 2. Open the snapshot fullscreen in the background to freeze the display
swayimg --fullscreen "$TMP_FILE" &
SWAY_PID=$!

# Brief pause to ensure swayimg renders before slurp takes focus
sleep 0.05

# 3. Select region over the static image
REGION=$(slurp -f "%wx%h+%x+%y")

# 4. Close swayimg immediately after selection is complete or canceled
kill "$SWAY_PID" 2>/dev/null

if [ -z "$REGION" ]; then
    exit 0
fi

# Crop the selected region from the original full snapshot
magick "$TMP_FILE" -crop "$REGION" +repage "$FILE" || exit 0

ACTION=$(notify-send "Screenshot Captured" "Copied to clipboard" --icon="$FILE" --action="edit=󰲶  annotate" --action="lens=  search" --action="scroll=  extend" --expire-time=5000)
case "$ACTION" in
    "edit")
        satty --filename "$FILE" --output-filename "$FILE" --disable-notifications
        ;;
    "lens")
        IMAGE_URL=$(curl -s -F "reqtype=fileupload" -F "time=1h" -F "fileToUpload=@$FILE" https://litterbox.catbox.moe/resources/internals/api.php)

        if [ -n "$IMAGE_URL" ]; then
            zen-browser "https://lens.google.com/uploadbyurl?url=${IMAGE_URL}"
            echo "${IMAGE_URL}"
        else
            notify-send "Google Lens Error" "Failed to upload image for search."
        fi
        ;;
    "scroll")
        notify-send "Scrolling Screenshot" "Select region and start scrolling" --expire-time=2000
        wayscrollshot --output "$FILE"
        ;;
esac

wl-copy < "$FILE"