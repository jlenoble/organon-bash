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

make-index-files() {
    local escaped_pattern=$(sed "s:/:\\\\/:g" <<< $BASHRC_DIR)

    rm $MAIN_FILE

    find $BASHRC_DIR -type d \
    | sed "/^$escaped_pattern$/d" \
    | xargs -i sh -c "make-index-file {}; echo . {}/index.bashrc >> $MAIN_FILE"
}

preprocess-source-file() {
    # Make sure $AVATAR is always resolved.
    # Replace all inclusions with a magic mangled string used elsewhere
    # to build wrapper run-only-once funcs.
    # This is a trick to determine in which order to include snipets
    if [ -f $1 ]; then
        cat $1 | sed -E "s:\\\$AVATAR:$AVATAR:;s%^(\s*)(\.|source)\s+(\S+)$% \
            if [ -f $BASHRC_DIR/\3 ]; then \
                echo '\1'\\\$(mangle-name $BASHRC_DIR/\3 $SCRIPT_DIR); \
            elif [ -f \3 ]; then \
                echo '\1'\\\$(mangle-name \3 $SCRIPT_DIR); \
            else \
                echo echo $1: unresolved \3 '>\&2'; \
            fi; \
        %e"
    fi
}


make-func-files() {
    # .func files are saved in $TMP_DIR. When run (only once each), they
    # output a mangled string that marks the order in which the corresponding
    # snipet code should be included in .bashrc.
    # The corresponding .tmp files contain the code to include devoid of any
    # nested includes.
    local DIR=""
    local BASE=""
    local FUNC_FILE=""
    local BASHRC_FILE=""
    local FUNC_NAME=""
    local i="    "

    for file in $TMP_DEPS; do
        BASE=$(basename $file)
        FUNC_NAME=$(mangle-name $file $SCRIPT_DIR)
        FUNC_FILE="$TMP_DIR/$FUNC_NAME.func"
        BASHRC_FILE="$TMP_DIR/$FUNC_NAME.tmp"

        # Build $FUNC_FILE
        echo "$FUNC_NAME() {" > "$FUNC_FILE"
    
        echo "${i}if [ -z \$var_$FUNC_NAME ]; then" >> "$FUNC_FILE"
        preprocess-source-file $file >> "$FUNC_FILE"
        echo "" >> "$FUNC_FILE"
        echo "${i}${i}echo \"\"" >> "$FUNC_FILE"
        echo "${i}${i}var_$FUNC_NAME=1" >> "$FUNC_FILE"
        echo "echo $FUNC_NAME" >> "$FUNC_FILE"
        echo "${i}fi" >> "$FUNC_FILE"
        echo "}" >> "$FUNC_FILE"

        # Build $BASHRC_FILE
        cat $file <(echo) | sed -E "s%^\s*(\.|source)\s+\S+$%%" > "$BASHRC_FILE"
    done
}

make-tmp-bashrc() {
    rm -f "$TMP_BASHRC_FILE"

    # Make sure all paths will be resolved
    for file in $(find "$TMP_DIR" -type f | grep "\.func$"); do
        preprocess-source-file $file >> "$TMP_BASHRC_FILE"
    done

    # Add entry point to run all nested name-mangled wrapper functions
    echo $(mangle-name "$BASHRC_DIR/index.bashrc" $SCRIPT_DIR) >> "$TMP_BASHRC_FILE"

    # Cache the order of execution of the wrapper functions
    mv "$TMP_BASHRC_FILE" "$PREVIOUS_TMP_BASHRC_FILE"
    source "$PREVIOUS_TMP_BASHRC_FILE" > "$TMP_BASHRC_FILE"
    mv "$TMP_BASHRC_FILE" "$PREVIOUS_TMP_BASHRC_FILE"

    # Build .bashrc in order, then delete tmp files
    for func in $(cat "$PREVIOUS_TMP_BASHRC_FILE"); do
        cat "$TMP_DIR/$func.tmp" >> "$TMP_BASHRC_FILE"
        rm "$TMP_DIR/$func.tmp" "$TMP_DIR/$func.func"
    done

    # Clean up .bashrc (remove comments and multiline blanks)
    mv "$TMP_BASHRC_FILE" "$PREVIOUS_TMP_BASHRC_FILE"
    sed -E -e "/^\s*#/d;" -e "N;/^\n$/D;P;D" "$PREVIOUS_TMP_BASHRC_FILE" > "$TMP_BASHRC_FILE" 
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
make-func-files
make-tmp-bashrc

cat "$TMP_BASHRC_FILE" | sed  "/^\s*#/d"

unset get-deps _collect-deps collect-deps
unset set-avatar preprocess-source-file
unset make-index-files make-func-files make-tmp-bashrc

unset AVATAR
unset SCRIPT_DIR BASHRC_DIR TMP_DIR
unset MAIN_FILE
unset TMP_BASHRC_FILE PREVIOUS_TMP_BASHRC_FILE
unset TMP_DEPS
