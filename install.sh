#!/usr/bin/env bash

# Target dir
BIN_DIR=~/bin

if [ ! -d $BIN_DIR ]; then
    mkdir $BIN_DIR
fi

# Collect and install scripts in $BIN_DIR
# Don't overwrite if already there
find $(readlink -f .) -type f \
| grep \.bash$ \
| sed 's/\.bash$//;/\/\.bash/d' \
| xargs -i sh -c "\
    if [ ! -L $BIN_DIR/\$(basename {}) ]; then \
        ln -s {}.bash $BIN_DIR/\$(basename {}); \
    fi"

unset BIN_DIR
