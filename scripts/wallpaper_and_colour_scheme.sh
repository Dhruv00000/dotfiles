#!/bin/bash

cd ${HOME}/Pictures/wallpapers
RAND=$(($(date +%N) % $(ls -h | wc -l) + 1))
IMG=$(ls -h | awk -v r=$RAND 'BEGIN{FS = "\n"; RS = ""} {print $r}')
swaybg --image ${HOME}/Pictures/wallpapers/$IMG &

iris ${HOME}/Pictures/wallpapers/$IMG --glass --dark 1 && mv ~/.cache/iris/colors-kitty.conf ~/.config/kitty/colors.conf && mv ~/.cache/iris/rofi.rasi ~/.config/rofi/colors/rofi.rasi && mv ~/.cache/iris/quickshell.qml ~/.config/quickshell/Colors.qml && mv ~/.cache/iris/starship.toml ~/.config/starship.toml && mv ~/.cache/iris/style.css ~/.config/wlogout/style.css

exit 0
