#powerline
source ~/.local/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh

# Go Path
if [ -d "/usr/local/go" ]; then
    export GOROOT=/usr/local/go
    export PATH=$GOROOT/bin:$PATH
fi
if [ -d "$HOME/dev/go" ]; then
    export GOPATH=$HOME/dev/go
    export PATH=$GOPATH/bin:$PATH
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

export VISUAL=vim
export HISTCONTROL=ignoredups

alias vim=nvim
alias vi=vim
