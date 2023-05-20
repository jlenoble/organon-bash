#!/usr/bin/env bash

_RC=$2
_SCRIPT_DIR=$3
_MAIN_DIR=$_SCRIPT_DIR/$_RC
_TMP_DIR="$_SCRIPT_DIR/.tmp"

if [ ! -d "$_TMP_DIR" ]; then
    mkdir "$_TMP_DIR"
fi

_MAIN_FILE="$_MAIN_DIR/index.$_RC"
_TMP_FILE="$_TMP_DIR/$_RC.tmp"

_AVATAR=$(get-avatar $1)

make-index-files "$_MAIN_FILE"

# Must be *after* make-index-files, to make sure indexes exist
_TMP_DEPS=$(collect-deps "$_MAIN_FILE" "$_AVATAR")

make-auxiliary-files "$_AVATAR" "$_MAIN_DIR" "$_TMP_DEPS"
make-tmp-rc "$_AVATAR" "$_MAIN_FILE" "$_TMP_FILE"

cat "$_TMP_FILE" | sed  "/^\s*#/d"

unset _AVATAR _RC
unset _SCRIPT_DIR _MAIN_DIR _MAIN_FILE
unset _TMP_DIR _TMP_FILE _TMP_DEPS
