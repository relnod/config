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
