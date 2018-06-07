#!/bin/bash

# set -x

usage() {
    echo "Dotfile manager"
    echo
    echo "Actions:"
    echo "    help                  Show this message"
    echo "    link [-d <string>]    Link dotfiles"
    echo "    unlink [-d <string>]  Unlink dotfiles"
}

get_files() {
    local dir=$1
    local files=""
    files="$(ls -A "$dir")"

    if [ "$gitignore" = true ] && [ -f "$dir.gitignore" ]; then
        files=${files/.gitignore/}
        for f in $(cat "$dir.gitignore") ; do
            files=${files/$f/}
        done
    fi
    echo "$files"
}

linkfile() {
    local from=$1
    local to=$2
    local file=$3

    if [ -d "$from$file" ]; then
        mkdir "$to$file"
        loop "$from$file/" "$to$file/"
    else
        if [ "$override" = true ] && [ ! -L "$to$file" ] && [ -f "$to$file" ]; then
            mv "$to$file" "$to$file.dotm.tmp"
        fi
        if [ ! -f "$to$file" ] && [ ! -L "$to$file" ]; then
            ln -s "$from$file" "$to"
        fi
    fi
}

unlinkfile() {
    local from=$1
    local to=$2
    local file=$3

    if [ -L "$to$file" ]; then
        rm "$to$file"

        if [ -f "$to$file.dotm.tmp" ]; then
            mv "$to$file.dotm.tmp" "$to$file"
        fi
    fi


    if [ ! -n "$(ls -A "$to")" ] && [ ! "$to" == "$TO" ]; then
        rm -rf "$to"
    fi
}

loop() {
    local from=$1
    local to=$2
    local files=""
    
    files="$(get_files "${from}")"

    for file in $files ; do
        if [ -d "$to$file" ]; then
            loop "$from$file/" "$to$file/"
        else
            $action "$from" "$to" "$file"
        fi
    done
}

has_parameter() {
    local parameter=$1

    echo "$*"

    if [[ "$*" =~ $parameter ]]; then
        echo true
        return
    fi

    echo 0
}

start_loop() {
    to="$(readlink -f ~/)/"

    for dir in $directories; do
        loop "$dir" "$to"
    done
}

link() {
    action="linkfile"
    start_loop
}

unlink () {
    action="unlinkfile"
    start_loop
}

from="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

directories="$(ls -d "${from}"/*/)"
action=""

override=false
gitignore=false

OPTIND=2
while getopts "luhdog:" opt; do
    case ${opt} in
        d)
            directories=""
            for dir in ${OPTARG}; do
                directories="${from}/${dir}/ $directories"
            done
            ;;
        h)
            usage
            exit 0
            ;;
        o)
            override=true
            ;;
        g)
            gitignore=true
            ;;
        *)
            echo ""
            usage
            exit 1
            ;;
    esac
done

case $1 in
    link)
        link
        exit 0
        ;;
    unlink)
        unlink
        exit 0
        ;;
    *)
        usage
        exit 0
        ;;
esac
