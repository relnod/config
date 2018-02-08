if [[ -f ~/.fzf.bash ]]; then
    source ~/.fzf.bash
fi

source ~/.config/shell/env.sh
source ~/.config/shell/aliases.sh
source ~/.config/shell/utils.sh

if [[ "$POWERLINE_FONT" == "true" ]]; then
    source ~/.config/bash/prompt.sh
fi
source ~/.config/bash/completion.sh
source ~/.config/bash/history.sh

if xset q &>/dev/null; then
    xmodmap ~/.Xmodmap
fi
