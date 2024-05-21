#!/usr/bin/env bash

ENTRY_FILE_STEM=$1

# Cannot guess ENTRY_FILE_STEM, must be provided
if [ -z $ENTRY_FILE_STEM ]; then
	echo "[ERROR] setup: ENTRY_FILE_STEM must be provided as \$1" >&2
	exit 1
fi

SCRIPT_DIR="$(find-script-dir ${BASH_SOURCE[0]})"
TMP_DIR="$SCRIPT_DIR/.tmp"

build-rc _ organonrc "$SCRIPT_DIR" "config/$ENTRY_FILE_STEM" config 2>&1 >/dev/null

# Exec custom built script
$TMP_DIR/organonrc.tmp

unset SCRIPT_DIR TMP_DIR
