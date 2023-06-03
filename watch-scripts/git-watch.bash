#!/usr/bin/env bash

GIT_DIR=$(find-script-dir ${BASH_SOURCE[0]})/../.git
GIT_HEAD_FILE=$GIT_DIR/logs/HEAD

cd $GIT_DIR/..

execute() {
    clear
    echo
    git --no-pager log -n 10 --reverse
}

execute

while sleep-until-modified $GIT_HEAD_FILE; do
    execute
done
