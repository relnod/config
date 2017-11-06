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


# prompt
END_COLOR="\e[m\]"
COLOR1="\[\e[30;47m\]"
COLOR2="\[\e[37;40m\]"

ARROW_L_BOLD=''
ARROW_L_THIN=''
ARROW_R_BOLD=''
ARROW_R_THIN=''

ps1="${COLOR1}\u ${END_COLOR}${COLOR2}${ARROW_R_BOLD}${END_COLOR}"
ps1="$ps1 \W ${COLOR1}$ARROW_R_BOLD "
ps1="$ps1 $(__git_ps1 '%s')${END_COLOR}${COLOR2}$ARROW_R_BOLD${END_COLOR} "
export PS1=$ps1

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
