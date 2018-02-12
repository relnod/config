#!/bin/sh

powerline_enable() {
    export POWERLINE_FONT='true'

    arrow_l_bold=''
    arrow_l_thin=''
    arrow_r_bold=''
    arrow_r_thin=''
}

powerline_disable() {
    export POWERLINE_FONT='false'

    arrow_l_bold=''
    arrow_l_thin=''
    arrow_r_bold=''
    arrow_r_thin=''
}

if test "$1" = "on"; then
    powerline_enable
fi

if test "$1" = "off"; then
    powerline_disable
fi

if test "$1" = "toggle"; then
    if test "$POWERLINE_FONT" = "true"; then
        powerline_disable
    else
        powerline_enable
    fi
fi

export ARROW_L_BOLD="$arrow_l_bold"
export ARROW_L_THIN="$arrow_l_thin"
export ARROW_R_BOLD="$arrow_r_bold"
export ARROW_R_THIN="$arrow_r_thin"
