#!/bin/zsh

OUTPUT_1=$(exa --oneline --tree --classify=always --level 2 --follow-symlinks --absolute=off --colour=always --icons=always --hyperlink=always --almost-all)

if (( ${#${(f)OUTPUT_1}} > 36 )); then
    exa --grid --classify=always --follow-symlinks --absolute=off --colour=always --icons=always --hyperlink=always --almost-all
    print -P "%F{yellow}\nexa output shortened from tree to grid.%f"
else
    print -r -- "$OUTPUT_1"
fi