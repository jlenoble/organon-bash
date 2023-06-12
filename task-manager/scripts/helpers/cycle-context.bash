#!/usr/bin/env bash

# Switch $1 context for another. Currently just cycle through contexts.
# If $1 is found within context directory $2, then switch to next context in directory,
# or back to first if $1 is last.
# If $1 is workon, switch to none
# Else let task handle the error.

# exit on first error and return errno
set -e

if [ -z $2 ]; then
    echo "You must provide a path to a 'contexts' dir as \$2" >&2
    exit 1
fi

contexts=($(ls $2 | sed "/index\.taskrc$/d;s/\.taskrc$//") "none")
i=0

if ! [[ "$1" =~ ^[[:alpha:]][[:alnum:]]*$ ]]; then
    # Pass along $1 and let `task` handle the error
    task context $1
fi

for context in "${contexts[@]}"; do
    i=$((i + 1))
    if [ $1 = $context ]; then
        context=${contexts[$i]}
        break
    fi
done

if [ ! -z $context ]; then
    if [[ $i < "${#contexts[@]}" ]]; then
        task context $context
    elif [ $1 = workon ]; then
        task context none
    else
        # Pass along $1 and let `task` handle the error
        task context $1
    fi
elif [ $i = "${#contexts[@]}" ]; then
    task context "${contexts[0]}"
fi

unset i contexts
