# bash completion
if ! [[ $(shopt -oq posix) ]]; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    . /etc/bash_completion
  fi
fi

if [[ -f /usr/share/git/completion/git-prompt.sh ]]; then
    source /usr/share/git/completion/git-prompt.sh
fi

if [ -n "$TMUX" ]; then
    source ~/.config/bash/prompt.sh
fi

# go
if [[ -d "/usr/local/go" ]]; then
    export GOROOT=/usr/local/go
    export PATH=$GOROOT/bin:$PATH
fi
if [[ -d "$HOME/go" ]]; then
    export GOPATH=$HOME/go
    export PATH=$GOPATH/bin:$PATH
elif [[ -d "$HOME/dev/go" ]]; then
    export GOPATH=$HOME/dev/go
    export PATH=$GOPATH/bin:$PATH
fi

# bash completion
if ! [[ $(shopt -oq posix) ]]; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    . /etc/bash_completion
  fi
fi

# fzf
if [[ -f ~/.fzf.bash ]]; then
    source ~/.fzf.bash

    if [[ $(command -v rg) != "" ]]; then
        export FZF_DEFAULT_COMMAND="rg --hidden -g '!.git' --files '.'"
    elif [[ $(command -v ag) != "" ]]; then
        export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
    else 
        export FZF_DEFAULT_COMMAND='find | grep -v ".git"'
    fi
fi

# editor
if [[ $(which nvim) = '' ]]; then
    editor=vim
else
    editor=nvim
fi
export VISUAL=$editor
export EDITOR=$editor

export HISTCONTROL=ignoredups
export HISTSIZE=2000

alias ls='ls --color'

alias g='git'
alias gc='git commit'
alias ga='git add'

xmodmap ~/.Xmodmap
