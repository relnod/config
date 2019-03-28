#!/bin/sh

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

# editor
export VISUAL=$(get_default_editor)
export EDITOR=$(get_default_editor)


export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.npm/bin"
