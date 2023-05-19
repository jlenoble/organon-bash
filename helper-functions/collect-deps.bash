#!/usr/bin/env bash

# Usage
#   collect-deps MAIN_FILE AVATAR
#
# Deps are in the form `. file_path` or `source file_path`.
# Prints the list of deps found, removing all redundant occurrences.

_MAIN_FILE=$1
_MAIN_DIR=$(dirname $_MAIN_FILE)

_AVATAR=$2

get-deps() {
    sed -E "s:\\\$AVATAR:$_AVATAR:;/^\s*(\.|source)\s+(\S+)$/!d;s%^\s*(\.|source)\s+(\S+)$% \
        if [ -f $_MAIN_DIR/\2 ]; then \
            echo $_MAIN_DIR/\2; \
        elif [ -f \2 ]; then \
            echo \2; \
        fi \
    %e" $1
}

collect-deps() {
    echo "$1"
    local -a list=($(get-deps $1))
    all_deps["$1"]=1
    local -i cnt=${#list[@]}
    if (( cnt > 0 )); then
        for f in "${list[@]}"; do
            if ! [[ -v all_deps["$f"] ]]; then
                collect-deps "$f"
            fi
        done
    fi
}

declare -A all_deps
collect-deps "$_MAIN_FILE"

unset _MAIN_FILE _MAIN_DIR _AVATAR all_deps