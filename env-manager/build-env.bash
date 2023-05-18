#!/usr/bin/env bash

get-deps() {
    sed -E "s:\\\$AVATAR:$AVATAR:;/^\s*(\.|source)\s+(\S+)$/!d;s%^\s*(\.|source)\s+(\S+)$% \
        if [ -f $BASHRC_DIR/\2 ]; then \
            echo $BASHRC_DIR/\2; \
        elif [ -f \2 ]; then \
            echo \2; \
        fi \
    %e" $1
}

_collect-deps() {
  echo "$1"
  local -a list=($(get-deps "$1"))
  seen["$1"]=1
  local -i cnt=${#list[@]}
  if (( cnt > 0 )); then
    for f in "${list[@]}"; do
      if ! [[ -v seen["$f"] ]]; then
        _collect-deps "$f"
      fi
    done
  fi
}

collect-deps() {
    local -A seen
    _collect-deps "$1"
}

set-avatar() {
    local preset_avatars=$(
        ls "$BASHRC_DIR/avatars" \
        | grep "\.bashoption$" \
        | sed -E 's/([^\.]+).*/\1/;/unknown/d'
    )

    AVATAR=${1:-unknown}
    [ "$1" = unknown ] && return

    if echo "${preset_avatars[@]}" | grep -qw "$AVATAR"; then
        return
    fi

    local BASHRC_AVATAR=$(egrep "\s*AVATAR=" ~/.bashrc | sed -E "s/\s*AVATAR=([^\n;]+)/\1/")
    AVATAR=${BASHRC_AVATAR:-$USER}
    AVATAR=${AVATAR:-unknown}

    if ! echo "${preset_avatars[@]}" | grep -qw "$AVATAR"; then
        AVATAR=unknown
    fi
}

include-bashrc-sources() {
    sed -i -E "s:\\\$AVATAR:$AVATAR:;s%^\s*(\.|source)\s+(\S+)$% \
        if [ -f $BASHRC_DIR/\2 ]; then \
            cat $BASHRC_DIR/\2; \
        elif [ -f \2 ]; then \
            cat \2; \
        else \
            echo echo $1: unresolved \2 '>\&2'; \
        fi \
    %e" $1
}

make-index-files() {
    local escaped_pattern=$(sed "s:/:\\\\/:g" <<< $BASHRC_DIR)

    rm $MAIN_FILE

    find $BASHRC_DIR -type d \
    | sed "/^$escaped_pattern$/d" \
    | xargs -i sh -c "make-index-file {}; echo . {}/index.bashrc >> $MAIN_FILE"
}

make-tmp-bashrc() {
    echo "" > "$PREVIOUS_TMP_BASHRC_FILE"
    cp "$MAIN_FILE" "$TMP_BASHRC_FILE"

    while ! diff "$TMP_BASHRC_FILE" "$PREVIOUS_TMP_BASHRC_FILE" > /dev/null 2>&1; do
        cp "$TMP_BASHRC_FILE" "$PREVIOUS_TMP_BASHRC_FILE"
        include-bashrc-sources "$TMP_BASHRC_FILE"
    done
}

SCRIPT_DIR=$( find-script-dir ${BASH_SOURCE[0]} )
BASHRC_DIR="$SCRIPT_DIR/bashrc"
TMP_DIR="$SCRIPT_DIR/.tmp"

if [ ! -d "$TMP_DIR" ]; then
    mkdir "$TMP_DIR"
fi

MAIN_FILE="$BASHRC_DIR/index.bashrc"
TMP_BASHRC_FILE="$TMP_DIR/bashrc.tmp"
PREVIOUS_TMP_BASHRC_FILE="$TMP_DIR/previous_bashrc.tmp"

set-avatar $1

TMP_DEPS=$(collect-deps "$MAIN_FILE")

make-index-files
make-tmp-bashrc

cat "$TMP_BASHRC_FILE" | sed  "/^\s*#/d"

unset get-deps _collect-deps collect-deps
unset set-avatar
unset include-bashrc-sources make-index-files
unset make-tmp-bashrc

unset AVATAR
unset SCRIPT_DIR BASHRC_DIR TMP_DIR
unset MAIN_FILE
unset TMP_BASHRC_FILE PREVIOUS_TMP_BASHRC_FILE
unset TMP_DEPS
