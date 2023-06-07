#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
    echo "No task to detail" >&2
    exit 1
fi

if [[ $1 =~ ^[[:digit:]]+$ ]]; then
    task_id=$1
    shift
    subtask=$(cleanup-task-description "$@")
else
    task_id=$(next-task-id)
    subtask=$(cleanup-task-description "$@")
fi

if [ -z $task_id ]; then
    echo "No task to split in smaller chunks" >&2
    exit 1
fi

# Task attributes
task_uuid=$(task _get $task_id.uuid)
task_tags=$(task _get $task_id.tags)
task_subtasks=$(task _get $task_id.subtasks)

# Check for redundancy
IFS=',' read -ra subtasks <<<"$task_subtasks"
declare -A descriptions
for uuid in "${subtasks[@]}"; do
    description=$(task _get $uuid.description)
    description=$(cleanup-task-description "$description")

    if [ "$description" == "$subtask" ]; then
        echo "'$2' is already a subtask of task $1" >&2
        exit 1
    fi

    descriptions[$uuid]="$description"
done

# New subtask
subtask_command=$(task add $subtask $(sed -E "s/([^,]+)/+\1/g;s/,/ /g;s/\+parent//g" <<<"$task_tags") subtask_of:$task_uuid)
echo $subtask_command
subtask_id=$(echo $subtask_command | grep -o -E '[0-9]+')
subtask_uuid=$(task _get $subtask_id.uuid)

# Sort subtasks
case ${#subtasks[@]} in
0)
    new_subtasks=$subtask_uuid
    ;;

*)
    echo "Current subtasks of task $1:"

    for n in "${!subtasks[@]}"; do
        uuid=${subtasks[$n]}
        description=${descriptions[$uuid]}
        echo "    $n $description"
    done

    n=0
    max=${#subtasks[@]}
    pos=$(ask-integer-from-to "Pick a position to insert '$subtask' within subtasks of task $task_id" $n $max)

    if [ $pos == 0 ]; then
        echo "Prepending '$subtask' to subtasks of task $task_id"
        new_subtasks="$subtask_uuid,$task_subtasks"
    elif [ $pos == $max ]; then
        echo "Appending '$subtask' to subtasks of task $task_id"
        new_subtasks="$task_subtasks,$subtask_uuid"
    else
        echo "Inserting '$subtask' within subtasks of task $task_id"
        new_subtasks="${subtasks[0]}"
        n=1
        while [ $n -lt $pos ]; do
            new_subtasks="$new_subtasks,${subtasks[$n]}"
            n=$(($n + 1))
        done
        new_subtasks="$new_subtasks,$subtask_uuid"
        while [ $n -lt $max ]; do
            new_subtasks="$new_subtasks,${subtasks[$n]}"
            n=$(($n + 1))
        done
    fi
    ;;
esac

# Update task
task $task_id mod subtasks:$new_subtasks
