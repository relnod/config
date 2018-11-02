#!/bin/sh

alias ls='ls --color'

alias ga='git add'
alias gs='git status'
alias gd='git diff'
alias gl='git log'
alias gch='git checkout'
alias gco='git commit'

alias dotpush='git add . && git commit -m "update" && git push'

alias bashrc='$EDITOR ~/.bashrc'
alias vimrc='$EDITOR ~/.vimrc'
alias init.vim='$EDITOR ~/.config/nvim/init.vim'
alias todo='$EDITOR ~/TODO'

eval $(thefuck --alias)
