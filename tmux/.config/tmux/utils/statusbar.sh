#!/bin/bash

seg_hostname() {
    echo "$(whoami)@$(hostname)"
}

seg_uptime() {
    uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* user.*//'
}

seg_load() {
    uptime | sed -E 's/.*average: *//; s/,/ |/g'
}

source ~/.config/shell/scripts/powerline.sh

color_bg_main="black"
color_bg_inactive="colour9"

if [[ $(tmux show-environment TMUX_OFF) == "TMUX_OFF=true" ]]; then
    color_bg_main="$color_bg_inactive"
fi

if [[ $1 == "window" ]]; then
    window="#[fg=white,bg=$color_bg_main] #I $ARROW_R_THIN #W "
    echo $window
fi

if [[ $1 == "window-current" ]]; then
    current="#[fg=$color_bg_main,bg=yellow]$ARROW_R_BOLD "
    current="$current#[fg=black,bg=yellow]#I $ARROW_R_THIN #W "
    current="$current#[fg=yellow,bg=$color_bg_main]$ARROW_R_BOLD"
    echo $current
fi

if [[ $1 == "left" ]]; then
    left="#[fg=black,bg=white] $(seg_hostname) "
    left="$left#[fg=white,bg=$color_bg_main]$ARROW_R_BOLD "
    echo $left
fi

if [[ $1 == "right" ]]; then
    right="#[fg=white,bg=$color_bg_main]$ARROW_L_BOLD"
    right="$right#[fg=black,bg=white] $(seg_uptime)"
    right="$right#[fg=$color_bg_main,bg=white] $ARROW_L_BOLD"
    right="$right#[fg=white,bg=$color_bg_main] $(seg_load)  "
    echo $right
fi
