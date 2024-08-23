#!/usr/bin/env bash

source strict-mode

_SCRIPT_DIR=$(find-script-dir ${BASH_SOURCE[0]})
_TMP_DIR="$_SCRIPT_DIR/../.tmp"

mkdir -p "$_TMP_DIR"
dconf dump /com/gexperts/Tilix/ >"$_TMP_DIR/tilix.conf"

unset _SCRIPT_DIR _TMP_DIR
