#!/bin/sh

if [[ "$1" == "on" ]]; then
    export POWELINE_FONT="true"
    export arrow_l_bold=''
    export arrow_l_thin=''
    export arrow_r_bold=''
    export arrow_r_thin=''
elif [[ "$1" == "off" ]]; then
    export POWELINE_FONT="false"
    export arrow_l_bold=''
    export arrow_l_thin=''
    export arrow_r_bold=''
    export arrow_r_thin=''
fi
