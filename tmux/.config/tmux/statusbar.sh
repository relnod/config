#!/bin/bash

function seg_hostname {
    hostname
}

function seg_uptime {
    uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* user.*//'
}

function seg_load {
    uptime | sed -E 's/.*average: *//; s/,/ |/g'
}

ARROW_L_BOLD=''
ARROW_L_THIN=''
ARROW_R_BOLD=''
ARROW_R_THIN=''

if [[ $1 == "window" ]]; then
    window="#[fg=white,bg=black] #I $ARROW_R_THIN #W "
    echo $window
fi

if [[ $1 == "window-current" ]]; then
    current="#[fg=black,bg=yellow]$ARROW_R_BOLD "
    current="$current#[fg=black,bg=yellow,bold]#I $ARROW_R_THIN #W "
    current="$current#[fg=yellow,bg=black]$ARROW_R_BOLD"
    echo $current
fi

if [[ $1 == "left" ]]; then
    left="#[fg=black,bg=white] $(seg_hostname) "
    left="$left#[fg=white,bg=black]$ARROW_R_BOLD "
    echo $left
fi

if [[ $1 == "right" ]]; then
    right="#[fg=white,bg=black]$ARROW_L_BOLD"
    right="$right#[fg=black,bg=white] $(seg_uptime)"
    right="$right#[fg=black,bg=white] $ARROW_L_BOLD"
    right="$right#[fg=white,bg=black] $(seg_load)  "
    echo $right
fi
