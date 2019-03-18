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
alias tmuxrc='$EDITOR ~/.tmux.conf'
alias nvimrc='$EDITOR ~/.config/nvim/init.vim'
alias i3rc='$EDITOR ~/.config/i3/config'
alias todo='$EDITOR ~/personal.todo'

# When vim is not installed. alias it to nvim
[ ! -x $(command -v vim) ] && alias vim='nvim'

[ -x "$(command -v thefuck)" ] && eval "$(thefuck --alias)"
