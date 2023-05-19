#!/usr/bin/env bash

# Enforce 'unknown' avatar preset. Any other unknown avatar arg $1 will
# result in $USER avatar preset, unless of course it itself isn't preset.
if [ "$1" = unknown ]; then
    echo unknown
    exit
fi

# Try to get _BASHRC_DIR from prompt $2 or environment
_BASHRC_DIR=${2:-$BASHRC_DIR}

# Otherwise it should be able to infer it from this script location
if [ -z $_BASHRC_DIR ]; then
    _SCRIPT_DIR=$( find-script-dir ${BASH_SOURCE[0]} )
    _BASHRC_DIR="$_SCRIPT_DIR/../env-manager/bashrc"
else
    _SCRIPT_DIR=""
fi

# If the following fails, then this script has been installed manually
# to a custom location and has lost its relative location with regard
# to the package avatar preset dir.
# We default then the only possible inferable avatars: root and $USER.
if [ -d "$_BASHRC_DIR/avatars" ]; then
    preset_avatars=$(
        ls "$_BASHRC_DIR/avatars" \
        | grep "\.bashoption$" \
        | sed -E 's/([^\.]+).*/\1/;/unknown/d'
    )
else
    preset_avatars=(root $USER)
fi

# Try to get _AVATAR from prompt $1 or environment
_AVATAR=${1:-$AVATAR}
# Otherwise tentatively use the 'unknown' preset
_AVATAR=${_AVATAR:-unknown}

# Return successfully if _AVATAR is found in presets.
# 'unknown' is not in presets, so won't return
if echo "${preset_avatars[@]}" | grep -qw "$_AVATAR" > /dev/null 2>&1; then
    echo $_AVATAR
    exit
fi

# Try now to guess _AVATAR

# AVATAR may be set but not exported in .bashrc
_AVATAR=$(egrep "^\s*AVATAR=" ~/.bashrc | sed -E "s/^\s*AVATAR=([^\n;]+)/\1/")
# If USER is not set, something is very wrong
_AVATAR=${_AVATAR:-$USER}
# last fallback
_AVATAR=${_AVATAR:-unknown}

# Any _AVATAR that is not preset ends up 'unknown' unless it is root or $USER.
#
# Note that if we reached this line, then no actual preset file was found, so
# the output value is just a *suggested* name for creating a first avatar,
# most likely $USER.
if ! echo "${preset_avatars[@]}" | grep -qw "$_AVATAR" > /dev/null 2>&1; then
    _AVATAR=unknown
fi

echo $_AVATAR

unset _SCRIPT_DIR _BASHRC_DIR _AVATAR preset_avatars
