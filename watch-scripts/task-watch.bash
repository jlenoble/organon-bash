#!/usr/bin/env bash

TASK_PENDING_DATA=$HOME/.task/pending.data

if [ ! -f "$TASK_PENDING_DATA" ]; then
    touch $TASK_PENDING_DATA
fi

execute() {
    clear
    next-task --mute_if_active_task
}

execute

while sleep-until-modified $TASK_PENDING_DATA; do
    execute
done
