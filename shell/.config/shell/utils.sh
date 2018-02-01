#!/bin/sh

get_git_branch() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo ""
        return
    fi

    branch=$(git symbolic-ref -q HEAD)
    branch=${branch##refs/heads/}
    branch=${branch:-HEAD}
    echo " $branch "
}

is_remote_session() {
    if [[ -n "$SSH_CLIENT" ]]; then
        echo "true"
    else
	echo "false"
    fi
}
