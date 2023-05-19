#!/usr/bin/env bash

# Make an index file for a directory that sources every file in that directory
# Usage:
#    make-index-file dir extension

dir=$1

if [ -z $dir ]; then
    echo "[ERROR] make-index-file: dir must be provided as \$1" >&2
    exit 1
fi

extension=$2

if [ -z $extension ]; then
    echo "[ERROR] make-index-file: must provide an extension as \$2" >&2
    exit 1
fi

# Don't break package versioning! Abort if .git/ found.
if [[ "$dir" =~ /\.git$ ]]; then
    echo "[ERROR] make-index-file: directory '$dir' is .git, won't write inside" >&2
    exit 1
# $dir contains a typo or directory was deleted
elif [ ! -d $dir ]; then
    echo "[ERROR] make-index-file: directory '$dir' doesn't exist" >&2
    exit 1
fi

find "$dir" -type f \
| sed -E "/index\.$extension$/d;/^.*\.$extension$/!d;s/^.*\.$extension$/. &/" > "$dir/index.$extension"

unset dir extension
