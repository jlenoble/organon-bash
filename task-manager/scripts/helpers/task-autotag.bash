#!/usr/bin/env bash

# Helper function for making short aliases to common `task` tagging one-liners
# See for example chore.bash for an obvious usage.

_tag=$1

# if _tag is a valid utf-8 identifier
if [[ "$_tag" =~ ^[[:alpha:]][[:alnum:]]*$ ]]; then
    shift

    _context_tag=$(task _get rc.context)
    _context_tag=${_context_tag:-todo}

    # then if first arg passed along is an integer, then modify the associated task
    # by tagging it with _tag, and maybe remove a todo tag
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        id=$1
        shift

        task $id mod $@ -todo -$_context_tag +$_tag
    # else create a new task from all passed along args and tag it with _tag
    else
        command=$(task add $@ +$_tag)
        id=$(echo $command | grep -o -E '[0-9]+')

        if [ $_context_tag != $_tag ]; then
            task $id mod -$_context_tag
        fi
    fi
# else abort
else
    echo "[ERROR] task-autotag: \$1 ($_tag) should be a valid utf-8 identifier" 1>&2
    exit 1
fi

unset _tag
