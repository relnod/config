# prompt
pwpath="$HOME/.local/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh"
if [[ -f  $pwpath ]]; then
    source $pwpath
else
    export PS1="\u@\h \[\033[32m\][\W] \[\033[33m\]\$(__git_ps1 '(%s) ')\[\033[00m\]$ "
fi

# go
if [[ -d "/usr/local/go" ]]; then
    export GOROOT=/usr/local/go
    export PATH=$GOROOT/bin:$PATH
fi
if [[ -d "$HOME/dev/go" ]]; then
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
    export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
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
