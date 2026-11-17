#!/bin/zsh

if [[ -z "$(ls -A)" ]]; then
    exit 0
fi

local non_empty_directories=( *(N/FD) )
if (( ${#non_empty_directories} == 0 )); then # If all folders in the current working directory are empty, then there is no need for a tree view.
    exa --grid --classify=always --follow-symlinks --absolute=off --colour=always --icons=always --hyperlink=always --almost-all
    print -P "%F{yellow}\nShortened exa output by switching to a grid view.%f"

else
    TREE_OUTPUT=$(exa --oneline --tree --classify=always --level 2 --follow-symlinks --absolute=off --colour=always --icons=always --hyperlink=always --almost-all)
    if (( ${#${(f)TREE_OUTPUT}} > 36 )); then # If the number of lines in TREE_OUTPUT is more than 36...
        exa --grid --classify=always --follow-symlinks --absolute=off --colour=always --icons=always --hyperlink=always --almost-all
        print -P "%F{yellow}\nShortened exa output by switching to a grid view.%f"

    else
        print -r -- "$TREE_OUTPUT"
    fi
fi