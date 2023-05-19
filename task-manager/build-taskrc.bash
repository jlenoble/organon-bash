#!/usr/bin/env bash

preprocess-source-file() {
    # Make sure $AVATAR is always resolved.
    # Replace all inclusions with a magic mangled string used elsewhere
    # to build wrapper run-only-once funcs.
    # This is a trick to determine in which order to include snipets
    if [ -f $1 ]; then
        cat $1 | sed -E "s:\\\$AVATAR:$AVATAR:;s%^(\s*)(\.|source)\s+(\S+)$% \
            if [ -f $TASKRC_DIR/\3 ]; then \
                echo '\1'\\\$(mangle-name $TASKRC_DIR/\3 $SCRIPT_DIR); \
            elif [ -f \3 ]; then \
                echo '\1'\\\$(mangle-name \3 $SCRIPT_DIR); \
            else \
                echo echo $1: unresolved \3 '>\&2'; \
            fi; \
        %e"
    fi
}


make-tmp-func-files() {
    # .func files are saved in $TMP_DIR. When run (only once each), they
    # output a mangled string that marks the order in which the corresponding
    # snipet code should be included in .taskrc.
    # The corresponding .tmp files contain the code to include devoid of any
    # nested includes.
    local DIR=""
    local BASE=""
    local FUNC_FILE=""
    local TASKRC_FILE=""
    local FUNC_NAME=""
    local i="    "

    for file in $TMP_DEPS; do
        BASE=$(basename $file)
        FUNC_NAME=$(mangle-name $file $SCRIPT_DIR)
        FUNC_FILE="$TMP_DIR/$FUNC_NAME.func"
        TASKRC_FILE="$TMP_DIR/$FUNC_NAME.tmp"

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

        # Build $TASKRC_FILE
        cat $file <(echo) | sed -E "s%^\s*(\.|source)\s+\S+$%%" > "$TASKRC_FILE"
    done
}

make-tmp-taskrc() {
    rm -f "$TMP_TASKRC_FILE"

    # Make sure all paths will be resolved
    for file in $(find "$TMP_DIR" -type f | grep "\.func$"); do
        preprocess-source-file $file >> "$TMP_TASKRC_FILE"
    done

    # Add entry point to run all nested name-mangled wrapper functions
    echo $(mangle-name "$TASKRC_DIR/index.taskrc" $SCRIPT_DIR) >> "$TMP_TASKRC_FILE"

    # Cache the order of execution of the wrapper functions
    mv "$TMP_TASKRC_FILE" "$PREVIOUS_TMP_TASKRC_FILE"
    source "$PREVIOUS_TMP_TASKRC_FILE" 2> /dev/null > "$TMP_TASKRC_FILE"
    mv "$TMP_TASKRC_FILE" "$PREVIOUS_TMP_TASKRC_FILE"

    # Build .taskrc in order, then delete tmp files
    for func in $(cat "$PREVIOUS_TMP_TASKRC_FILE"); do
        cat "$TMP_DIR/$func.tmp" >> "$TMP_TASKRC_FILE"
        #rm "$TMP_DIR/$func.tmp" "$TMP_DIR/$func.func"
    done

    # Clean up .taskrc (remove comments and multiline blanks)
    mv "$TMP_TASKRC_FILE" "$PREVIOUS_TMP_TASKRC_FILE"
    sed -E -e "/^\s*#/d" -e "N;/^\n$/D;P;D" "$PREVIOUS_TMP_TASKRC_FILE" > "$TMP_TASKRC_FILE" 
}

SCRIPT_DIR=$( find-script-dir ${BASH_SOURCE[0]} )
TASKRC_DIR="$SCRIPT_DIR/taskrc"
TMP_DIR="$SCRIPT_DIR/.tmp"

if [ ! -d "$TMP_DIR" ]; then
    mkdir "$TMP_DIR"
fi

MAIN_FILE="$TASKRC_DIR/index.taskrc"
TMP_TASKRC_FILE="$TMP_DIR/taskrc.tmp"
PREVIOUS_TMP_TASKRC_FILE="$TMP_DIR/previous_taskrc.tmp"

AVATAR=$(get-avatar $1)

make-index-files "$MAIN_FILE"

# Must be *after* make-index-files, to make sure indexes exist
TMP_DEPS=$(collect-deps "$MAIN_FILE")

make-tmp-func-files
make-tmp-taskrc

cat "$TMP_TASKRC_FILE" | sed  "/^\s*#/d"

unset get-deps _collect-deps collect-deps
unset set-avatar preprocess-source-file
unset make-index-files make-tmp-func-files make-tmp-taskrc

unset AVATAR
unset SCRIPT_DIR TASKRC_DIR TMP_DIR
unset MAIN_FILE
unset TMP_TASKRC_FILE PREVIOUS_TMP_TASKRC_FILE
unset TMP_DEPS
