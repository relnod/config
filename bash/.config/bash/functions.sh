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
    if [ ! -z "$(pgrep tmux)" ]; then
        sessions=$(tmux ls | cut -d ':' -f1)

        # If we are in a session, remove the current session from list.
        if [ ! -z "$TMUX" ]; then
            echo "here"
            curr_session=$(tmux display-message -p '#S')
            sessions=$(echo "$sessions" | sed "s/$curr_session//g")
        fi
        list="$sessions"
    fi

    # Append tmuxinator projects to list.
    for i in $(tmuxinator ls | sed '1d'); do
        list="$list $i"
    done

    selected=$(echo "$list" | sed 's/ /\n/g' | awk 'NF' | sort | uniq | fzf)

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

function serve-start {
    name=$1
    path=$(readlink -f "$2")

    local free_port
    for port in $(seq 4444 65000); do
        echo -ne "\035" | telnet 127.0.0.1 "$port" > /dev/null 2>&1; [ $? -eq 1 ] && free_port="$port" && break
    done

    if [ "$(docker ps -a | grep "$name")" ]; then
        echo "Already serving $name. Run 'serve-stop $name' to stop serving."
        return
    fi

    docker run --name "$name" -v "$path:/usr/share/nginx/html:ro" -p "$free_port":80 -d nginx > /dev/null 2>&1
    echo "Serving files from '$path' at :$free_port"

    xdg-open "http://localhost:$free_port" > /dev/null 2>&1
}

function serve-stop {
    name=$1
    docker stop "$name" > /dev/null 2>&1
    docker rm "$name" > /dev/null 2>&1
}
