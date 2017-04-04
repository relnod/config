#powerline
source ~/.local/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh

# Go Path
if [ -d "/usr/local/go" ]; then
    export GOPATH=$HOME/dev/go
    export GOROOT=/usr/local/go
    export PATH=$GOPATH/bin:$PATH
    export PATH=$GOROOT/bin:$PATH
fi
if [ -d "/usr/lib/go" ]; then
    export GOPATH=$HOME/dev/go
    export PATH=$GOPATH/bin:$PATH
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'


export VISUAL=vim
export HISTCONTROL=ignoredups
