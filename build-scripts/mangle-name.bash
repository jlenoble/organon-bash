#!/usr/bin/env bash

# Custom name mangling scheme
# Usage:
#    mangle-name $FILE_PATH [$RELATIVE_TO]
#
# All dir names must exist. Base names may or may not exist.
# Currently replaces:
#   / with _1
#   . with _2
#   - with _3

RELATIVE_TO=${2:-`pwd`}

echo $(realpath --relative-to="$RELATIVE_TO" "$1") | sed "s|/|_1|g;s/\./_2/g;s/-/_3/g"

unset RELATIVE_TO
