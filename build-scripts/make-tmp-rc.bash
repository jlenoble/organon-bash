#!/usr/bin/env bash

_AVATAR=$1

_MAIN_FILE=$2
_MAIN_DIR=$(dirname $_MAIN_FILE)
_ENTRY_FILE_SUBDIR=$4

if [ $(basename $_MAIN_DIR) == "$_ENTRY_FILE_SUBDIR" ]; then
    _MAIN_DIR=$(dirname $_MAIN_DIR)
fi

_PARENT_DIR=$(dirname $_MAIN_DIR)

_TMP_DIR=$(dirname $3)
tmp_base=$(basename $3)

tmp_file=$_TMP_DIR/$tmp_base
old_tmp_file=$_TMP_DIR/old_$tmp_base

rm -f "$tmp_file"

# Make sure all paths will be resolved
for file in $(find "$_TMP_DIR" -type f | grep "\.func$"); do
    preprocess-source-file $file $_AVATAR $_MAIN_DIR >>"$tmp_file"
done

# Add entry point to run all nested name-mangled wrapper functions
echo $(mangle-name "$_MAIN_FILE" $_PARENT_DIR) >>"$tmp_file"

# Cache the order of execution of the wrapper functions
mv "$tmp_file" "$old_tmp_file"
source "$old_tmp_file" >"$tmp_file"
mv "$tmp_file" "$old_tmp_file"

# Build .bashrc in order, then delete tmp files
for func in $(cat "$old_tmp_file"); do
    cat "$_TMP_DIR/$func.tmp" >>"$tmp_file"
    rm "$_TMP_DIR/$func.tmp" "$_TMP_DIR/$func.func"
done

# Clean up .bashrc (remove comments and multiline blanks)
mv "$tmp_file" "$old_tmp_file"
sed "N;/^\n$/D;P;D" "$old_tmp_file" >"$tmp_file"

if [ ! -z $_ENTRY_FILE_SUBDIR ]; then
    chmod u+x "$tmp_file"
fi

unset _AVATAR _MAIN_DIR _PARENT_DIR _TMP_DIR _ENTRY_FILE_SUBDIR
unset tmp_base tmp_file old_tmp_file
