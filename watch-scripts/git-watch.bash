#!/usr/bin/env bash

SCRIPT_DIR="$(find-script-dir ${BASH_SOURCE[0]})"
PROJECT_DIR="$SCRIPT_DIR/../.."
target="${1:-vault}"
GIT_DIR="$PROJECT_DIR/$target/.git"
GIT_HEAD_FILE="$GIT_DIR/logs/HEAD"

case $target in
organon-bash | organon-wagtail | vault)
    cd "$GIT_DIR/.."

    execute() {
        clear
        echo
        git --no-pager log -n 10 --reverse
    }

    execute

    while sleep-until-modified "$GIT_HEAD_FILE"; do
        execute
    done
    ;;

*) ;;
esac

unset target SCRIPT_DIR GIT_TARGET GIT_HEAD_FILE
