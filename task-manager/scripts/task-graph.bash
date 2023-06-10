#!/usr/bin/env bash

source strict-mode

set +u
task_id=${1:-$(next-task-id)}
flag=${2:-""}
set -u
indent="    "

# Task attributes
task_uuid=$(task _get $task_id.uuid)
task_subtasks=$(task _get $task_id.subtasks)
task_subtask_of=$(task _get $task_id.subtask_of)
task_description=$(task _get $task_id.description)
task_start=$(task _get $task_id.start)
task_status=$(task _get $task_id.status)

FONTCOLOR=""
STARTLINETHROUGH=""
ENDLINETHROUGH=""

if [ ! -z $task_start ]; then
    if [ -z $task_subtasks ]; then
        FONTCOLOR="fontcolor=green"
    else
        FONTCOLOR="fontcolor=blue"
    fi
fi

if [ "$task_status" == "completed" ]; then
    FONTCOLOR="fontcolor=gray42"
    STARTLINETHROUGH="<s>"
    ENDLINETHROUGH="</s>"
fi

# Called from prompt by user
if [ "$flag" != "--self_referential" ]; then
    # Climb up the task tree up to a top task
    if [ ! -z "$task_subtask_of" ]; then
        task-graph "$task_subtask_of"
        exit
    fi

    # Top task
    graph_links="digraph {
${indent}rankdir="LR"
${indent}n$task_id [$FONTCOLOR label=\"$task_id. $STARTLINETHROUGH$task_description$ENDLINETHROUGH\"]"
else
    # Subtask
    graph_links="${indent}n$task_id [$FONTCOLOR label=\"$task_id. $STARTLINETHROUGH$task_description$ENDLINETHROUGH\"]"
fi

# Collect links
IFS=',' read -ra subtasks <<<"$task_subtasks"
for uuid in "${subtasks[@]}"; do
    status=$(task _get $uuid.status)

    if [ $status = completed ] || [ $status = deleted ]; then
        continue
    fi

    id=$(task _get $uuid.id)
    description=$(task _get $uuid.description)

    graph_links="$graph_links
$(task-graph $id --self_referential)
${indent}n$task_id -> n$id"
done

if [ "$flag" != "--self_referential" ]; then
    # Close digraph
    echo "$graph_links
}" >~/.task/next_task.dot
    dot -Tjpg ~/.task/next_task.dot >~/.task/next_task.jpg
else
    # Extend digraph
    echo "$graph_links"
fi
