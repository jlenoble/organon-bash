#!/usr/bin/env bash

# cf. https://stackoverflow.com/a/246128

# Find the directory of a script, resolving all links
# Usage:
#    find-script-dir ${BASH_SOURCE[0]}

find-script-dir() {
    local DIR=""
    local SOURCE=$1

    while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
        SOURCE=$(readlink "$SOURCE")
        [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done

    echo $( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
}

find-script-dir $1
