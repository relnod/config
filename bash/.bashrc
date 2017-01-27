

#powerline
if [ -r ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh ]; then
    source ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
fi
if [[ -r /usr/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh ]]; then
    source /usr/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh
fi

export GOPATH=$HOME/dev/go
export GOROOT=/usr/local/go
export PATH=$GOPATH/bin:$PATH
export PATH=$GOROOT/bin:$PATH
