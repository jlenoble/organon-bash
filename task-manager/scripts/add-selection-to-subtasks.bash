#!/usr/bin/env bash

task_id=${1:-$(next-task-id)}

if [ -z $task_id ]; then
    echo No task to be added to >&2
    exit 1
fi

task_uuid=$(task _get $task_id.uuid)
subtasks=$(task _get $task_id.subtasks | sed -e 's/,/ /g')

if [ ! -z "$subtasks" ]; then
    subtask_ids=$(task $subtasks | grep "^ID" | sed -e 's/ID //g')
fi

filter="$(task _get rc.report.idonly.filter) +selected"
selected_subtask_ids=$(task "rc.report.idonly.filter:$filter" rc.verbose: idonly)

subtask_ids=$(echo $subtask_ids $selected_subtask_ids | sed -e 's/ /\n/g' | sort | uniq)

subtasks=$(echo $(task $(echo $subtask_ids) | grep "^UUID" | sed -e 's/UUID //g') | sed -e 's/ /,/g')

task $filter mod subtask_of:$task_uuid && task $task_id mod subtasks:$subtasks && task +selected mod -selected
task
