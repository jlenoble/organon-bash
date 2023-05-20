#!/usr/bin/env bash

_AVATAR=$2
_MAIN_DIR=$3

_PARENT_DIR=$(dirname $_MAIN_DIR)

# Make sure $AVATAR is always resolved.
# Replace all inclusions with a magic mangled string used elsewhere
# to build wrapper run-only-once funcs
if [ -f $1 ]; then
    cat $1 | sed -E "s:\\\$AVATAR:$_AVATAR:; \
        s%^(\s*)(\.|source)\s+(\S+)$% \
            if [ -f $_MAIN_DIR/\3 ]; then \
                echo '\1'\\\$(mangle-name $_MAIN_DIR/\3 $_PARENT_DIR); \
            elif [ -f \3 ]; then \
                echo '\1'\\\$(mangle-name \3 $_PARENT_DIR); \
            else \
                echo echo $1: unresolved \3 '>\&2'; \
            fi; \
        %e"
fi

unset _AVATAR _MAIN_DIR _PARENT_DIR
