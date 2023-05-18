#!/usr/bin/env bash

# Make an index file for a directory that sources every file in that directory
# Usage:
#    make-index-file $DIR

extension=${2:-.bashrc}

if [ ! -d "$1" ]; then
    exit 1
fi

find "$1" -type f \
| sed -E "/index\\$extension$/d;/^.*\\$extension$/!d;s/^.*\\$extension$/. &/" > "$1/index$extension"

unset extension
