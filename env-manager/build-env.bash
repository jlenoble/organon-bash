#!/usr/bin/env bash

AVATAR=${1:-unknown}

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

SCRIPT_DIR=$( find-script-dir ${BASH_SOURCE[0]} )
BASHRC_DIR="$SCRIPT_DIR/bashrc"
TMP_DIR="$SCRIPT_DIR/.tmp"

MAIN_FILE="$BASHRC_DIR/index.bashrc"
TMP_BASHRC_FILE="$TMP_DIR/bashrc.tmp"
PREVIOUS_TMP_BASHRC_FILE="$TMP_DIR/previous_bashrc.tmp"

make-index-files

echo "" > "$PREVIOUS_TMP_BASHRC_FILE"
cp "$MAIN_FILE" "$TMP_BASHRC_FILE"

while ! diff "$TMP_BASHRC_FILE" "$PREVIOUS_TMP_BASHRC_FILE" > /dev/null 2>&1; do
    cp "$TMP_BASHRC_FILE" "$PREVIOUS_TMP_BASHRC_FILE"
    include-bashrc-sources "$TMP_BASHRC_FILE"
done

cat "$TMP_BASHRC_FILE" | sed  "/^\s*#/d"

unset include-bashrc-sources make-index-files
unset AVATAR SCRIPT_DIR BASHRC_DIR MAIN_FILE TMP_BASHRC_FILE PREVIOUS_TMP_BASHRC_FILE
