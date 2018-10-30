#!/bin/bash

dcd() {
    cd "$(dotm config "$1" --path)" || exit
}

_dcd_completions()
{
    if [ "${#COMP_WORDS[@]}" != "2" ]; then
        return
    fi
    COMPREPLY=($(compgen -W "$(dotm list)" "${COMP_WORDS[1]}"))
}
complete -F _dcd_completions dcd
