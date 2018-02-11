COLOR1="%{$fg[black]%}%{$bg[white]%}"
COLOR2="%{$fg[white]%}%{$bg[black]%}"

setopt prompt_subst

ps1="${COLOR1} %n %{$reset_color%}${COLOR2}${arrow_r_bolD}%{$reset_color%}"
ps1="$ps1 \$(get_curr_dir_name) ${COLOR1}${arrow_r_bold}"
ps1=${ps1}'$(get_git_branch)'
ps1=${ps1}"%{$reset_color%}${COLOR2}${arrow_r_bold}%{$reset_color%} "
export PS1=$ps1
