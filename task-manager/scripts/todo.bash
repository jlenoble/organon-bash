#!/usr/bin/env bash

# Basic default wrapper for `task`.
#
# Usage:
#   todo [any number of valid task args that can follow the add `command`]
# Examples:
#   todo Go shopping
#   todo Fix bug +urgent due:today

context=$(task _get rc.context)
context=${context:-todo}

if [[ $context =~ :select(ing|ed)$ ]]; then
    context=$(sed -E "s/:select(ing|ed)$//" <<<"$context")

    if [ $context = none ]; then
        context=todo
    fi
fi

task add $@ +$context
