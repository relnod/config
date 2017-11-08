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

source ~/.config/bash/prompt.sh

# go
if [[ -d "/usr/local/go" ]]; then
    export GOROOT=/usr/local/go
    export PATH=$GOROOT/bin:$PATH
fi
if [[ -d "$HOME/dev/go" ]]; then
    export GOPATH=$HOME/dev/go
    export PATH=$GOPATH/bin:$PATH
fi


# fzf
if [[ -f ~/.fzf.bash ]]; then
    source ~/.fzf.bash
    export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
fi

# editor
if [[ $(command -v nvim) != '' ]]; then
    editor=nvim
elif [[ $(command -v nvim) != '' ]]; then
    editor=vim
fi
export VISUAL=$editor
export EDITOR=$editor

export HISTCONTROL=ignoredups
export HISTSIZE=2000

alias ls='ls --color'

alias g='git'
alias gc='git commit'
alias ga='git add'
