zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
