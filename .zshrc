export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt INC_APPEND_HISTORY
unsetopt EXTENDED_HISTORY


autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit # These  compinit lines are required for the 'hab' plugin to work.
source /usr/share/zsh-antidote/antidote.zsh
antidote load
source ~/.zsh_plugins.zsh

export ET_NOTIFY_TIMEOUT=15000
export ET_NOTIFY_COMMAND='~/scripts/notification_plugin_hook.sh'

export COLORED_MAN_THEME=ansi # Matches plugin colours to the terminal's current colour scheme.

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

unarchive() {
    for file in "$@"; do
        local dir="$file"
        dir="${dir%.tar.*}"
        dir="${dir%.*}"
        mkdir -p "$dir" && bsdtar -xf "$file" -C "$dir" && modded_rm "$file"
    done
}

modded_mkdir() {
    mkdir "$1" && cd "$1"
}
alias "mkdir"="modded_mkdir"

diff_wrapper() {
    diff --recursive --unified $1 $2 | diff-so-fancy
}
alias diff='diff_wrapper'

alias ls='exa --oneline --tree --classify=always --level 2 --follow-symlinks --absolute=off --colour=always --icons=always --hyperlink=always --almost-all'

alias cat='bat'

alias fzf='fzf --style full --preview "fzf-preview.sh {}" --bind "focus:transform-header:file --brief {}"'


chpwd() {
    ls
}


export PATH="$PATH:/home/dhruv/.local/bin"


_evalcache starship init zsh
_evalcache zoxide init zsh --cmd cd
clear


fastfetch --logo Crux


# ZSH history clear=ning script
fc -W

tac ~/.zsh_history | awk '{
    cmd=$0
    sub(/^: [0-9]+:[0-9]+;/, "", cmd)
    if (!seen[cmd]++) {
        print $0
    }
}' | tac > ~/.zsh_history.tmp

mv ~/.zsh_history.tmp ~/.zsh_history