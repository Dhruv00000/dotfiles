#!/bin/bash

WALLPAPER_FOLDER="${HOME}/Pictures/wallpapers"

cd "$WALLPAPER_FOLDER"
IMG=$(ls | shuf -n 1)
swaybg --image "$WALLPAPER_FOLDER/$IMG" & iris "$WALLPAPER_FOLDER/$IMG" --glass --dark 1 && mv ~/.cache/iris/colors-kitty.conf ~/.config/kitty/colors.conf && mv ~/.cache/iris/rofi.rasi ~/.config/rofi/colors/rofi.rasi && mv ~/.cache/iris/quickshell.qml ~/.config/quickshell/Colors.qml && mv ~/.cache/iris/starship.toml ~/.config/starship.toml && mv ~/.cache/iris/style.css ~/.config/wlogout/style.css

exit 0
