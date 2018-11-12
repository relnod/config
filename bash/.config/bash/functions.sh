#!/bin/bash

# dcd cd's into the local path of a dotfile profile.
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

# t collects all tmux sessions and tmuxinator projects, then provides a
# selection via fzf. Depending on the type that was selected, it attaches,
# switches to a tmux session or start a new tmuxinator project.
function t {
    local list
    local sessions

    # If tmux server is running, collect tmux sessions.
    if [[ "$TMUX" != "" ]]; then
        sessions=$(tmux ls | cut -d ':' -f1)
        # Remove current session from list.
        curr_session=$(tmux display-message -p '#S')
        list=$(echo "$sessions" | sed -e "s/$curr_session//")
    fi

    # Append tmuxinator projects to list.
    for i in $(tmuxinator ls | sed '1d'); do
        list="$list $i"
    done

    selected="$(echo "$list" | sed 's/ /\n/g' | awk 'NF' | sort | uniq | fzf)"

    if [[ $sessions == *"$selected"* ]]; then
        if [[ "$TMUX" != "" ]]; then
            tmux switch -t "$selected"
        else
            tmux attach -t "$selected"
        fi
    else
        tmuxinator start "$selected"
    fi
}

# p selects a project from ~/dev/repos and cd's into it.
function p {
    project=$(find ~/dev/repos -mindepth 3 -maxdepth 3 -type d | fzf)
    cd "$project" || exit
}
