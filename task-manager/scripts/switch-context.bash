#!/usr/bin/env bash

# Get current task context and pick another in context list.
# Currently just cycling through. A better heuristic should be
# devised.

context=$(task _get rc.context)
context=${context:-none}
count=$(task +PENDING count 2>/dev/null)
_SCRIPT_DIR=$(find-script-dir ${BASH_SOURCE[0]})
_CONTEXTS_DIR="$_SCRIPT_DIR/../../task-manager/taskrc/contexts"

_cycle-context() {
    cycle-context $(sed -E "s/:selecting$//" <<<"$context") "$_CONTEXTS_DIR"
    count=$(task +PENDING count 2>/dev/null)
    context=$(task _get rc.context)
    context=${context:-none}
    if [ $count = 0 ]; then
        echo No task left in context "'$context'" >&2
    fi
}

_maybe-skip-context() {
    while [ $count = 0 ] && [ $context != none ]; do
        _cycle-context
    done
}

if [ -z $1 ]; then
    _cycle-context
    _maybe-skip-context
    exit
fi

if [ $1 != workon ]; then
    task +workon mod -workon -parent 2>/dev/null
fi

if [ $1 = selecting ]; then
    if [[ $context =~ :selecting$ ]]; then
        tmp_context=$context
    else
        rcfile=~/.taskrc

        tmp_context="$context:selecting"

        if ! grep "\.$tmp_context\." "$rcfile" >/dev/null 2>&1; then
            echo "context.$tmp_context.read  =" \
                $(sed -E "/^context\.$context\.read/!d;s/context\.$context\.read=(.*)/\1/" "$rcfile") \
                $(sed -E "/^context\.selecting\.read/!d;s/context\.selecting\.read=(.*)/\1/" "$rcfile") \
                >>"$rcfile"
            echo "context.$tmp_context.write =" \
                $(sed -E "/^context\.$context\.write/!d;s/context\.$context\.write=(.*)/\1/" "$rcfile") \
                $(sed -E "/^context\.selecting\.write/!d;s/context\.selecting\.write=(.*)/\1/" "$rcfile") \
                >>"$rcfile"
        fi
    fi

    task context $tmp_context
else
    task context $1
fi

unset context tmp_context rcfile _SCRIPT_DIR _CONTEXTS_DIR
