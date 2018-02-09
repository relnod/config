END_COLOR="\e[m\]"
COLOR1="\[\e[30;47m\]"
COLOR2="\[\e[37;40m\]"

arrow_l_bold=''
arrow_l_thin=''
arrow_r_bold=''
arrow_r_thin=''

if [[ "$POWERLINE_FONT" != "true" ]]; then
    arrow_l_bold=''
    arrow_l_thin=''
    arrow_r_bold=''
    arrow_r_thin=''
fi

seg_remote() {
    if [[ $(is_remote_session) == "true" ]]; then
        echo "@$(hostname)"
    fi
}

ps1="${COLOR1}\u$(seg_remote)${END_COLOR}${COLOR2}${arrow_r_bold}${END_COLOR}"
ps1="$ps1 \W ${COLOR1}${arrow_r_bold}"
ps1="$ps1\$(get_git_branch)${END_COLOR}${COLOR2}${arrow_r_bold}${END_COLOR} "
export PS1=$ps1
