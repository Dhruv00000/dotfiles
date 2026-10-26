if [[ "$TERM_PROGRAM" == "vscode" && -z "$VSCODE_INJECTION" ]]; then
    source "$(codium --locate-shell-integration-path zsh)"
fi


export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
unsetopt EXTENDED_HISTORY

typeset -g _LAST_HISTORY_LINE=""
zshaddhistory() {
    _LAST_HISTORY_LINE="${1%%$'\n'}"
    return 1
}
precmd() {
    local -i exit_status=$?
    if [[ -n "$_LAST_HISTORY_LINE" ]]; then # _LAST_HISTORY_LINE can be empty on shell startup or when Enter is pressed with an empty prompt.
        if (( exit_status != 127 )); then
            print -sr -- "$_LAST_HISTORY_LINE"
        fi
        _LAST_HISTORY_LINE="" # Need to reset _LAST_HISTORY_LINE because otherwise, executing a command, and then pressing enter on an empty prompt messes with the if condition above.
    fi
}


export warhol_ignore_ls=1
export warhol_ignore_diff=1

source /usr/share/zsh-antidote/antidote.zsh
antidote load
source ~/.zsh_plugins.zsh

export ET_NOTIFY_TIMEOUT=15000
export ET_NOTIFY_COMMAND='~/scripts/notification_plugin_hook.sh'

export COLORED_MAN_THEME=ansi # Matches plugin colours to the terminal's current colour scheme.

export ABBR_SET_EXPANSION_CURSOR=1

unset LS_COLORS # Stops warhol from messing with exa's colourization

# zstyle ':autocomplete:*' add-semicolon no
# zstyle ':autocomplete:*' delay 0.5 # stops the autocomplete plugin from ruining performance


source <(fzf --zsh)
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
export PATH="$PATH:/usr/share/fzf/"


source /usr/share/doc/pkgfile/command-not-found.zsh


modded_rm() {
    for file in "$@"; do

        if [[ ! -e "$file" && ! -L "$file" ]]; then
            echo "rm: cannot remove '$file': No such file or directory" >&2
            continue
        fi

        local base="${file:t}"
        local destination_file="$HOME/.local/share/Trash/files/$base"
        local info_file="$HOME/.local/share/Trash/info/${base}.trashinfo"

        if [[ -e "$destination_file" || -e "$info_file" ]]; then # Handling duplicate file names in the trash.
            local suffix="_$(date +%Y-%m-%d_%H:%M:%S)_$RANDOM"
            base="${base}${suffix}"
            destination_file="$HOME/.local/share/Trash/files/$base"
            info_file="$HOME/.local/share/Trash/info/${base}.trashinfo"
        fi

        cat <<EOF > "$info_file"
[Trash Info]
Path=${file:A}
DeletionDate=$(date +%Y-%m-%dT%H:%M:%S)
EOF

        mv "$file" "$destination_file"

    done
}
alias rm='modded_rm'
alias rm_default='command rm'

modded_mkdir() {
    mkdir "$1" && cd "$1"
}
alias "mkdir"="modded_mkdir"

modded_touch() {
  for argument in "$@"; do
    local dir=$(dirname "$argument")
    if [ "$dir" != "." ]; then
        mkdir --parents "$dir"
    fi
    command touch "$argument"
  done
}
alias "touch"="modded_touch"

unarchive() {
    for file in "$@"; do
        local dir="$file"
        dir="${dir%.tar.*}"
        dir="${dir%.*}"
        mkdir -p "$dir" && bsdtar -xf "$file" -C "$dir" && modded_rm "$file"
    done
}

diff_wrapper() {
    diff --recursive --unified $1 $2 | diff-so-fancy
}
alias diff='diff_wrapper'

alias ls='exa --oneline --tree --classify=always --level 2 --follow-symlinks --absolute=off --colour=always --icons=always --hyperlink=always --almost-all'

alias cat='bat'

alias fzf='fzf --style full --preview "fzf-preview.sh {}" --bind "focus:transform-header:file --brief {}"'

alias archive='tar -czvf'


chpwd() {
    ls
    pwd > ~/.cache/zsh/last_working_directory
}

if [[ -r ~/.cache/zsh/lastpwd ]]; then
    command cd "$(cat ~/.cache/zsh/last_working_directory)" 2>/dev/null
fi


export PATH="$PATH:/home/dhruv/.local/bin"


_evalcache starship init zsh
_evalcache zoxide init zsh --cmd cd
clear


replace_multiple_dots() {
    local dots=$LBUFFER[-3,-1]
    if [[ $dots =~ "^[ //\"']?\.\.$" ]]; then
        LBUFFER=$LBUFFER[1,-3]'../.'
    fi
    zle self-insert
}
zle -N replace_multiple_dots
bindkey '.' replace_multiple_dots


bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

bindkey '^H' backward-kill-word

bindkey '^z' undo
bindkey '^y' redo


fastfetch --logo Crux