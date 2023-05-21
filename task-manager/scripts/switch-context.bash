#!/usr/bin/env bash

# Get current task context and pick another in context list.
# Currently just cycling through. A better heuristic should be
# devised. 

context=$(task _get rc.context)
context=${context:-none}
_SCRIPT_DIR=$(find-script-dir  ${BASH_SOURCE[0]})
_CONTEXTS_DIR="$_SCRIPT_DIR/../../task-manager/taskrc/contexts"

cycle-context "$context" "$_CONTEXTS_DIR"

unset context _SCRIPT_DIR _CONTEXTS_DIR