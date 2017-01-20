

#powerline
if [ -r ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh ]; then
    source ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
fi
if [[ -r /usr/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh ]]; then
    source /usr/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh
fi

GOPPATH=$HOME/dev/go
PATH=$GOPPATH/bin:$PATH
