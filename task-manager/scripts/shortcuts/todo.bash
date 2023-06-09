#!/usr/bin/env bash

# Basic default wrapper for `task`.
#
# Usage:
#   todo [any number of valid task args that can follow the add `command`]
# Examples:
#   todo Go shopping
#   todo Fix bug +urgent due:today

context=$(task _get rc.context)
context=${context:-none}

command=$(task add $@ +todo)
id=$(echo $command | grep -o -E '[0-9]+')

if [ $context != none ]; then
    task $id mod -$context
fi
