export ZSH="$HOME/.oh-my-zsh"
plugins=(git zsh-autosuggestions fast-syntax-highlighting zsh-autocomplete auto-notify autoupdate zsh-safe-rm zsh-clean-history colored-man-pages-plus command-not-found zsh-history-on-success)
export AUTO_NOTIFY_THRESHOLD=20
export AUTO_NOTIFY_CANCEL_ON_SIGINT=1
export AUTO_NOTIFY_TITLE="Command %command finished executing"
export COLORED_MAN_THEME=ansi # Matches plugin colours to terminal colour scheme
export ZSH_CLEAN_HISTORY_SIMILARITY=0.1
export ZSH_HISTORY_CTRL_C_DURATION_SECONDS=1
zstyle ':autocomplete:*' add-semicolon no
zstyle ':autocomplete:*' delay 0.5 # stops the autocomplete plugin from ruining performance
source $ZSH/oh-my-zsh.sh


source <(fzf --zsh)
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
export PATH="$PATH:/usr/share/fzf/"


alias rm='safe-rm -r'
alias ls='ls --all'
alias cat='bat'
alias fzf='fzf --style full --preview "fzf-preview.sh {}" --bind "focus:transform-header:file --brief {}"'

alias package-install='yay --needed -S'
alias package-search='yay -Ss'
alias package-uninstall='yay -Rn'


clean-history --remove-rare --quiet
fastfetch
eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd cd)"


chpwd() {
    ls
}

export PATH="$PATH:/home/dhruv/.local/bin"
