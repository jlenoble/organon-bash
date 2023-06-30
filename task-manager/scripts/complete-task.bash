#!/usr/bin/env bash

# Complete next task, either $1 or top most one in current context

task_id=${1:-$(next-task-id)}

workon-parent $task_id

task $task_id done
task
