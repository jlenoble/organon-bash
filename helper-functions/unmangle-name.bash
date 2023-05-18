#!/usr/bin/env bash

# Custom name unmangling scheme
# Usage:
#    unmangle-name $FILE_PATH [$RELATIVE_TO]
#
# All dir names must exist. Base names may or may not exist.
# Currently replaces:
#   _1 with /
#   _2 with .

RELATIVE_TO=${2:-`pwd`}

echo $(realpath $(sed "s|_1|/|g;s/_2/\./g" <<<"$RELATIVE_TO/$1"))

unset RELATIVE_TO