#!/bin/bash

if [[ -f ~/.bashrc.local ]]; then
    source ~/.bashrc.local
fi

if [[ -f ~/.fzf.bash ]]; then
    source ~/.fzf.bash
fi

source ~/.config/shell/env.sh
source ~/.config/shell/aliases.sh
source ~/.config/shell/utils.sh

if [[ $POWERLINE_FONT = "true" ]]; then
    source ~/.config/shell/scripts/powerline.sh on
fi

if [ -n "$SSH_TTY" ] || [ -n "$SSH_CLIENT" ]; then
    source ~/.config/bash/remote.sh
fi

source ~/.config/bash/prompt.sh
source ~/.config/bash/completion.sh
source ~/.config/bash/functions.sh
source ~/.config/bash/history.sh

if xset q &>/dev/null; then
    xmodmap ~/.Xmodmap
fi
