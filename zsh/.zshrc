autoload -U colors && colors

source ~/.config/shell/utils.sh
source ~/.config/shell/env.sh
source ~/.config/shell/aliases.sh

source ~/.config/zsh/prompt.zsh
source ~/.config/zsh/history.zsh
source ~/.config/zsh/completion.zsh

bindkey -v

if xset q &>/dev/null; then
    xmodmap ~/.Xmodmap
fi
