#!/usr/bin/env bash

task_id=${1:-$(next-task-id)}

if [ -z $task_id ]; then
    echo No task to work on >&2
    exit 1
elif [ $task_id == none ]; then
    echo Now working on nothing specific
    task context none
    task +workon mod -workon -parent
    exit
elif ! [[ $task_id =~ ^[[:digit:]]+$ ]]; then
    echo task_id \"$task_id\" is not a mere integer >&2
    exit 1
fi

task +workon mod -workon -parent
task +selected mod -selected

task $task_id mod +workon +parent
task subtask_of:$(task _get $task_id.uuid) mod +workon

switch-context workon
