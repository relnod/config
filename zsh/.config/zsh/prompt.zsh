COLOR1="%{$fg[black]%}%{$bg[white]%}"
COLOR2="%{$fg[white]%}%{$bg[black]%}"

ARROW_L_BOLD=''
ARROW_L_THIN=''
ARROW_R_BOLD=''
ARROW_R_THIN=''

setopt prompt_subst

ps1="${COLOR1} %n %{$reset_color%}${COLOR2}${ARROW_R_BOLD}%{$reset_color%}"
ps1="$ps1 \$(get_curr_dir_name) ${COLOR1}${ARROW_R_BOLD}"
ps1=${ps1}'$(get_git_branch)'
ps1=${ps1}"%{$reset_color%}${COLOR2}${ARROW_R_BOLD}%{$reset_color%} "
export PS1=$ps1
