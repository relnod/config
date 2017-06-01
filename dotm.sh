#!/bin/bash
#set -x

get_files() {
    local dir=$1
    local files=$(ls -A $dir)

    if [ $(has_parameter {"--gitignore"}) = true ] && [ -f $dir.gitignore ]
    then
        files=${files/.gitignore/}
        for f in $(cat $dir.gitignore) ; do
            files=${files/$f/}
        done
    fi
    echo $files
}

linkfile() {
    local from=$1
    local to=$2
    local file=$3

    if [ -d $from$file ]
    then
        mkdir $to$file
        loop $from$file/ $to$file/
    else
        if [ $(has_parameter {"--override"}) = true ] && [ ! -L $to$file ] && [ -f $to$file ]
        then
            mv "$to$file" "$to$file.dotm.tmp"
        fi
        if [ ! -f $to$file ] && [ ! -L $to$file ]
        then
            ln -s $from$file $to
        fi
    fi
}

unlinkfile() {
    local from=$1
    local to=$2
    local file=$3

    if [ -L $to$file ]
    then
        rm $to$file
    fi

    if [ -f $to$file.dotm.tmp ]
    then
        mv $to$file.dotm.tmp $to$file
    fi

    if [ ! -n "$(ls -A $to)" ] && [ ! "$to" == "$TO" ]
    then
        rm -rf $to
    fi
}

depth=0
loop() {
    local from=$1
    local to=$2

    local files=$(get_files ${from})

    for file in $files ; do
        if [ -d $to$file ]
        then
            loop $from$file/ $to$file/
        else
            $action $from $to $file
        fi
    done
}


start_loop() {
    FROM="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    TO="$(realpath ~/)/"

    for from in $FROM/*/ ; do
        loop $from $TO
    done
}

has_parameter() {
    local parameter=$1

    if [[ "$*" =~ "$parameter" ]]
    then
        echo true
        return
    fi

    echo 0
}

usage() {
    echo "Dotfile manager"
    echo
    echo "Actions:"
    echo "    help   Show this message"
    echo "    link   Link dotfiles"
    echo "    unlink unlink dotfiles"
}

link() {
    action="linkfile"
    start_loop
}

unlink () {
    action="unlinkfile"
    start_loop
}

case $1 in
    link)
        link
        exit 0
        ;;
    unlink)
        unlink
        exit 0
        ;;
    help|*)
        usage
        exit 0
        ;;
esac
