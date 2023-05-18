#!/usr/bin/env bash

# Make an index file for a directory that sources every file in that directory
# Usage:
#    make-index-file $DIR

if [ ! -d "$1" ]; then
    exit 1
fi

find "$1" -type f \
| sed -E "/index.bashrc$/d;/^.*\.bashrc$/!d;s/^.*\.bashrc$/. &/" > "$1/index.bashrc"
