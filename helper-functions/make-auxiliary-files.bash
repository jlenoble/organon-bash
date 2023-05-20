#!/usr/bin/env bash

_AVATAR=$1
_MAIN_DIR=$2
_TMP_DEPS=$3

_PARENT_DIR=$(dirname $_MAIN_DIR)
_TMP_DIR=$_PARENT_DIR/.tmp

# .func files are saved in $TMP_DIR. When run (only once each), they
# output a mangled string that marks the order in which the corresponding
# snipet code should be included in .taskrc.
# The corresponding .tmp files contain the code to include devoid of any
# nested includes.
_i="    "

for file in $_TMP_DEPS; do
    _FUNC_NAME=$(mangle-name $file $_PARENT_DIR)
    _FUNC_FILE="$_TMP_DIR/$_FUNC_NAME.func"
    _TMP_FILE="$_TMP_DIR/$_FUNC_NAME.tmp"

    # Make tmp file where all lines but includes are removed
    cat $file <(echo) | sed -E "/^\s*(\.|source)\s+\S+$/!d" > "$_TMP_FILE"

    # Build $FUNC_FILE using the commented out versions of sources
    echo "$_FUNC_NAME() {" > "$_FUNC_FILE"

    echo "${_i}if [ -z \$var_$_FUNC_NAME ]; then" >> "$_FUNC_FILE"
    preprocess-source-file "$_TMP_FILE" $_AVATAR $_MAIN_DIR >> "$_FUNC_FILE"
    echo "${_i}${_i}var_$_FUNC_NAME=1" >> "$_FUNC_FILE"
    echo "${_i}${_i}echo $_FUNC_NAME" >> "$_FUNC_FILE"
    echo "${_i}fi" >> "$_FUNC_FILE"
    echo "}" >> "$_FUNC_FILE"

    # Rebuild $_TMP_FILE with sources except for sourcing lines
    cat $file <(echo) | sed -E "s%^\s*(\.|source)\s+\S+$%%" > "$_TMP_FILE"
done

unset _AVATAR _MAIN_DIR _PARENT_DIR _TMP_DIR
unset _BASE _FUNC_FILE _TMP_FILE _FUNC_NAME _i