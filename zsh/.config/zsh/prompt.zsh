if [[ -f /usr/share/git/completion/git-prompt.sh ]]; then
    source /usr/share/git/completion/git-prompt.sh
fi

COLOR1="%{$fg[black]%}%K{white}"
COLOR1="%{$fg[white]%}%{$bg[black]%}"

ARROW_L_BOLD=''
ARROW_L_THIN=''
ARROW_R_BOLD=''
ARROW_R_THIN=''

ps1="${COLOR1}%n %{$reset_color%}${COLOR2}${ARROW_R_BOLD}%{$reset_color%}"
ps1="$ps1 %/ ${COLOR1}${ARROW_R_BOLD}"
ps1="$ps1 \$(__git_ps1 '%s')%{$reset_color%}${COLOR2}${ARROW_R_BOLD}%{$reset_color%}"
export PS1=$ps1
