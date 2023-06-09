#!/usr/bin/env bash

# Select $1 or top task

task_id=${1:-$(next-task-id)}

if [ -z $task_id ]; then
    echo No task to unselect >&2
    exit 1
fi

task $task_id mod -selected

task
