#powerline
source ~/.local/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh

# Go Path
if [ -d "/usr/local/go" ]; then
    export GOPATH=$HOME/dev/go
    export GOROOT=/usr/local/go
    export PATH=$GOPATH/bin:$PATH
    export PATH=$GOROOT/bin:$PATH
fi

export HISTCONTROL=ignoredups

alias ll="ls -la"
alias ls="ls -CF"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
