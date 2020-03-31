#!/bin/sh

color_bg_main="black"
color_bg_inactive="colour9"

if [[ $(tmux show-environment TMUX_OFF) == "TMUX_OFF=true" ]]; then
    color_bg_main="$color_bg_inactive"
fi

if [[ $1 == "window" ]]; then
    window="#[fg=white,bg=$color_bg_main] #I:#W "
    echo $window
fi

if [[ $1 == "window-current" ]]; then
    current="#[fg=black,bg=yellow] #I:#W "
    echo $current
fi

if [[ $1 == "left" ]]; then
    left="#[fg=black,bg=white] $(whoami)@$(hostname) "
    left="$left#[fg=white,bg=$color_bg_main] "
    echo $left
fi
