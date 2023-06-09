#!/usr/bin/env bash

# Usage:
#   remove-subtask ID/UUID [ID/UUID]

source strict-mode

set +u
if [ -z "$1" ]; then
    echo "No task to remove subtasks from" >&2
    exit 1
fi

if [ -z "$2" ]; then
    task_id=$(next-task-id)
    subtask_id="$1"
else
    task_id="$1"
    subtask_id="$2"
fi
set -u

if [ -z $task_id ]; then
    echo "No task to remove subtasks from" >&2
    exit 1
fi

task_id=$(task _get $task_id.id)
subtask_id=$(task _get $subtask_id.id)
task_uuid=$(task _get $task_id.uuid)
subtask_uuid=$(task _get $subtask_id.uuid)

parent_uuid=$(task _get $subtask_id.subtask_of)

if [ -z $parent_uuid ] || [ $parent_uuid != $task_uuid ]; then
    echo "Safety check failed: subtask_of $parent_uuid != task_uuid $task_uuid" >&2
    exit 1
fi

previous_subtasks=$(task _get $task_id.subtasks)

# Remove from subtasks array
IFS=',' read -ra subtasks <<<"$previous_subtasks"
subtasks="${subtasks[@]/$subtask_uuid/}"

new_subtasks=$(echo $subtasks | sed -e 's/ /,/g')

# Update task
task $task_id mod subtasks:$new_subtasks
task $subtask_id mod subtask_of: -workon -selected

# Print pending tasks
task
