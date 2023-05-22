#!/usr/bin/env bash

# Complete next task, either $1 or top most one in current context

task_id=${1:-$(next-task-id)}

if [ -z $task_id ]; then
    echo No task to complete >&2
    exit 1
fi

task $task_id done
