#/bin/bash

if [ -n "$TMUX" ]; then
    preexec () {
        export $(tmux show-environment | grep "^SSH_AUTH_SOCK") > /dev/null 2>&1
        export $(tmux show-environment | grep "^DISPLAY") > /dev/null 2>&1
    }

    preexec_invoke_exec () {
        [ -n "$COMP_LINE" ] && return                     # do nothing if completing
        [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return # don't cause a preexec for $PROMPT_COMMAND
        local this_command=`history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//g"`; # obtain the command from the history, removing the history number at the beginning
        preexec "$this_command"
    }

    trap 'preexec_invoke_exec' DEBUG
fi
