#!/usr/bin/env bash

_MAIN_FILE=$1

# Cannot guess MAIN_FILE, must be provided
if [ -z $_MAIN_FILE ]; then
    echo "[ERROR] make-index-files: MAIN_FILE must be provided as \$1" >&2
    exit 1
fi

_MAIN_DIR=$(dirname $_MAIN_FILE)

extension=${_MAIN_FILE##*.}

# Must have an extension for index files
if [ -z $extension ]; then
    echo "[ERROR] make-index-files: $_MAIN_FILE has no extension" >&2
    exit 1
fi

escaped_dir_name=$(sed "s:/:\\\\/:g" <<< $_MAIN_DIR)

rm -f $_MAIN_FILE

# generate all index files, don't enter any .git dir
find $_MAIN_DIR -type d \
| sed "/^$escaped_dir_name$/d" \
| sed "/.git$/d" \
| xargs -i sh -c "make-index-file {} '$extension'; echo . {}/index.$extension >> $_MAIN_FILE"

unset _MAIN_FILE _MAIN_DIR extension escaped_dir_name