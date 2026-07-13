fastfetch


eval "$(starship init zsh)"


alias package-install='yay --needed -S'
alias package-search='yay -Ss'
alias package-uninstall='yay -Rn'
alias cat='bat'


zstyle ':autocomplete:*' add-semicolon no
zstyle ':autocomplete:*' delay 0.5


export ZSH="$HOME/.oh-my-zsh"
plugins=(git zsh-autosuggestions fast-syntax-highlighting zsh-autocomplete auto-notify autoupdate zsh-safe-rm zsh-clean-history colored-man-pages-plus command-not-found)


export AUTO_NOTIFY_THRESHOLD=20
export AUTO_NOTIFY_CANCEL_ON_SIGINT=1
export AUTO_NOTIFY_TITLE="Command %command finished executing"
export COLORED_MAN_THEME=ansi

source $ZSH/oh-my-zsh.sh


alias rm='safe-rm -r'
alias ls='ls -a'

clean-history --remove-rare --quiet

chpwd() {
    ls -la
}

eval "$(zoxide init zsh --cmd cd)"

# Created by `pipx` on 2026-07-06 14:54:13
export PATH="$PATH:/home/dhruv/.local/bin"
