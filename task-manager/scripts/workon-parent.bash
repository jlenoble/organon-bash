#!/usr/bin/env bash

task_id=${1:-$(next-task-id)}

if [ -z $task_id ]; then
    echo No task to complete >&2
    exit 1
fi

parent_uuid=$(task _get $task_id.subtask_of)

if [ ! -z $parent_uuid ]; then
    parent_id=$(task _get $parent_uuid.id)
    workon $parent_id
    task
fi
