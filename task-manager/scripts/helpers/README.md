# Task helper scripts

## clean-task-description

trim $1, remove extra spaces, convert all to lower case.

## cycle-context

```bash
# Contexts are context1 and context2
# Context is none
swith-context
# Context is context1
swith-context
# Context is context2
swith-context
# Context is none
```
## next-task-id

Echoes the `id` of the top most task in the table produced by the `task` command,
or nothing if the latter is empty.

## task-autotag

Backbone of `chore`, `gds`, `organon`, *etc*.

Usage: `task-autotag TAG [[TASK_ADD_VALID_ARGUMENT+] or [TASK_ID TASK_MOD_VALID_ARGUMENT*]]`