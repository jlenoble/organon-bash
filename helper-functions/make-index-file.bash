#!/usr/bin/env bash

# Make an index file for a directory that sources every file in that directory
# Usage:
#    make-index-file $DIR

make-index-file() {
    local DIR=$1

    if [ ! -d "$DIR" ]; then
        exit 1
    fi

    find "$DIR" -type f \
    | sed -E "/index.bashrc$/d;s/^(.*\.bashrc)$/. &/" > "$DIR/index.bashrc"
}

make-index-file $1
