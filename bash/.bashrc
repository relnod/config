#!/bin/bash

# Enable vi mode for bash.
# Unfortunately I didn't manage to show the current vi mode in the bash prompt.
# See: https://unix.stackexchange.com/questions/22527/change-cursor-shape-or-color-to-indicate-vi-mode-in-bash
set -o vi

# Run keychain to start ssh-agent or load existing one.
if [ -f ~/.ssh/id_rsa ]; then
    eval `keychain --quiet --agents ssh --eval id_rsa`
else
    eval `keychain --quiet --agents ssh`
fi

# Source local ~/.bashrc.local
# This file can be used for local configurations,
# that should not be tracked.
[ -f ~/.bashrc.local ] && source ~/.bashrc.local

# Source fzf.bash for setup, autocompletion and keybindings.
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Source fzf-extras
[[ -e "$HOME/.fzf-extras/fzf-extras.sh" ]] && source "$HOME/.fzf-extras/fzf-extras.sh"

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

get_default_editor() {
    if [[ $(command -v nvim) != "" ]]; then
        echo "nvim"
    elif [[ $(command -v vim) != "" ]]; then
        echo "vim"
    else
        echo "vi"
    fi
}

get_fzf_default_command() {
    if [[ $(command -v rg) != "" ]]; then
        echo "rg --hidden -g '!.git' --files '.'"
    elif [[ $(command -v ag) != "" ]]; then
        echo 'ag --hidden --ignore .git -g ""'
    else 
        echo 'find | grep -v ".git"'
    fi
}

# go
if [[ -d "/usr/local/go" ]]; then
    export GOROOT=/usr/local/go
    export PATH=$GOROOT/bin:$PATH
fi
if [[ -d "$HOME/go" ]]; then
    export GOPATH=$HOME/go
    export PATH=$GOPATH/bin:$PATH
fi

# fzf
if [[ -d "$HOME/.fzf/bin" && ! "$PATH" == *$HOME/.fzf/bin* ]]; then
    export PATH="$PATH:$HOME/.fzf/bin"
fi

if [[ $(command -v fzf) != "" ]]; then
    export FZF_DEFAULT_COMMAND=$(get_fzf_default_command)
fi

# Set default editor
export VISUAL=$(get_default_editor)
export EDITOR=$(get_default_editor)

# Set default browser for terminal applications
export BROWSER='firefox'

# Update $PATH
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.npm/bin"

# Set some aliases for convenience.
alias ls='ls --color'
alias ll='ls -alF'

alias ga='git add'
alias gs='git status'
alias gd='git diff'
alias gl='git log'
alias gch='git checkout'
alias gco='git commit'

alias dotpush='git add . && git commit -m "update" && git push'

alias bashrc='$EDITOR ~/.bashrc'
alias vimrc='$EDITOR ~/.vimrc'
alias tmuxrc='$EDITOR ~/.tmux.conf'
alias nvimrc='$EDITOR ~/.config/nvim/init.vim'
alias i3rc='$EDITOR ~/.config/i3/config'
alias todo='$EDITOR ~/todo.txt'

# When vim is not installed, alias it to nvim
[ ! -x $(command -v vim) ] && alias vim='nvim'

[ -x "$(command -v thefuck)" ] && eval "$(thefuck --alias)"

# Source bash completion files
[ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
[ -f /etc/bash_completion ] && . /etc/bash_completion
if [[ -d ~/.bash_completion.d ]]; then
    for file in ~/.bash_completion.d/* ; do
        source "$file"
    done
fi

# dcd cd's into the local path of a dotfile profile.
function dcd {
    cd "$(dotm config profile."$1".path | envsubst)" || exit
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

# gp selects a project from ~/go/src and cd's into it.
function gp {
    project=$(find ~/go/src -mindepth 3 -maxdepth 3 -type d | fzf)
    cd "$project" || exit
}

# serve-start serves static files from a via an nginx docker container from a
# given path.
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

# serve-stop is the the counter part of serve-start and stops/removes the docker
# container.
function serve-stop {
    name=$1
    docker stop "$name" > /dev/null 2>&1
    docker rm "$name" > /dev/null 2>&1
}

# When in a remote session source an additional bashrc.
# Since it is sourced at the end, it is possible to override everthing there.
[ -n "$SSH_TTY" ] || [ -n "$SSH_CLIENT" ] && source ~/.config/bash/remote.sh
