if [[ -f ~/.fzf.bash ]]; then
    source ~/.fzf.bash
fi

source ~/.config/shell/env.sh
source ~/.config/shell/aliases.sh
source ~/.config/shell/utils.sh

if [[ $POWERLINE_FONT = "true" ]]; then
    source ~/.config/shell/scripts/powerline.sh on
fi

if [[ -z "SSH_TTY" ]]; then
    echo "test"
    source ~/.config/bash/remote.sh
fi

source ~/.config/bash/prompt.sh
source ~/.config/bash/completion.sh
source ~/.config/bash/history.sh

if xset q &>/dev/null; then
    xmodmap ~/.Xmodmap
fi
