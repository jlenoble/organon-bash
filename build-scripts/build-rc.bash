#!/usr/bin/env bash

_RC=$2
_SCRIPT_DIR=$3
_MAIN_DIR=$_SCRIPT_DIR/$_RC
_ENTRY_FILE_STEM=${4:-index}
_ENTRY_FILE_SUBDIR=$5
_TMP_DIR="$_SCRIPT_DIR/.tmp"

if [ ! -d "$_TMP_DIR" ]; then
    mkdir "$_TMP_DIR"
fi

_MAIN_FILE="$_MAIN_DIR/$_ENTRY_FILE_STEM.$_RC"
_TMP_FILE="$_TMP_DIR/$_RC.tmp"

_AVATAR=$(get-avatar $1)

if [ "$_ENTRY_FILE_STEM" == index ]; then
    make-index-files "$_MAIN_FILE"
fi

# Must be *after* make-index-files, to make sure indexes exist
_TMP_DEPS=$(collect-deps "$_MAIN_FILE" "$_AVATAR" "$_ENTRY_FILE_SUBDIR")

make-auxiliary-files "$_AVATAR" "$_MAIN_DIR" "$_TMP_DEPS"
make-tmp-rc "$_AVATAR" "$_MAIN_FILE" "$_TMP_FILE" "$_ENTRY_FILE_SUBDIR"

cat "$_TMP_FILE" | sed "/^\s*#/d"

unset _AVATAR _RC _ENTRY_FILE_STEM _ENTRY_FILE_SUBDIR
unset _SCRIPT_DIR _MAIN_DIR _MAIN_FILE
unset _TMP_DIR _TMP_FILE _TMP_DEPS
