#!/bin/bash

# Run keychain to start ssh-agent or load existing one.
if [ -f ~/.ssh/id_rsa ]; then
    eval `keychain --quiet --agents ssh --eval id_rsa`
else
    eval `keychain --quiet --agents --eval`
fi

# Source local ~/.bashrc.local
# This file can be used for local configurations,
# that should not be tracked.
[ -f ~/.bashrc.local ] && source ~/.bashrc.local

# Source fzf.bash for setup, autocompletion and keybindings.
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# When an X server is running source ~/.Xmodmap for key mappings.
[ -x "$(command -v xset)" ] && xset q &>/dev/null && xmodmap ~/.Xmodmap

# Simple prompt styling.
# Prints the current directory and a $.
# Example: "~ $"
export PS1="\W \[\e[31m\]$\[\e[0m\] "

# History size
export HISTFILE=~/.bhistfile
export HISTSIZE=2000
export HISTCONTROL=ignoredups

# Write the history after every command. This makes sure, that when entering a
# new bash sessions all commands the the currently open sessions are in the
# history.
export PROMPT_COMMAND="history -a"

# TODO: move content from files into this one.
source ~/.config/shell/env.sh
source ~/.config/shell/aliases.sh
source ~/.config/bash/completion.sh
source ~/.config/bash/functions.sh

if [[ $POWERLINE_FONT = "true" ]]; then
    source ~/.config/shell/scripts/powerline.sh on
fi

# When in a remote session source an additional bashrc.
# Since it is sourced at the end, it is possible to override everthing there.
[ -n "$SSH_TTY" ] || [ -n "$SSH_CLIENT" ] && source ~/.config/bash/remote.sh
