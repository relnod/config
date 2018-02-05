#!/bin/bash

seg_hostname() {
    whoami
}

seg_uptime() {
    uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* user.*//'
}

seg_load() {
    uptime | sed -E 's/.*average: *//; s/,/ |/g'
}

arrow_l_bold=''
arrow_l_thin=''
arrow_r_bold=''
arrow_r_thin=''

color_bg_main="black"
color_bg_inactive="colour9"

if [[ $(tmux show-environment TMUX_OFF) == "TMUX_OFF=true" ]]; then
    color_bg_main="$color_bg_inactive"
fi

if [[ $1 == "window" ]]; then
    window="#[fg=white,bg=$color_bg_main] #I $arrow_r_thin #W "
    echo $window
fi

if [[ $1 == "window-current" ]]; then
    current="#[fg=$color_bg_main,bg=yellow]$arrow_r_bold "
    current="$current#[fg=black,bg=yellow]#I $arrow_r_thin #W "
    current="$current#[fg=yellow,bg=$color_bg_main]$arrow_r_bold"
    echo $current
fi

if [[ $1 == "left" ]]; then
    left="#[fg=black,bg=white] $(seg_hostname) "
    left="$left#[fg=white,bg=$color_bg_main]$arrow_r_bold "
    echo $left
fi

if [[ $1 == "right" ]]; then
    right="#[fg=white,bg=$color_bg_main]$arrow_l_bold"
    right="$right#[fg=black,bg=white] $(seg_uptime)"
    right="$right#[fg=$color_bg_main,bg=white] $arrow_l_bold"
    right="$right#[fg=white,bg=$color_bg_main] $(seg_load)  "
    echo $right
fi
