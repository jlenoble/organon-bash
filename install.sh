#!/usr/bin/env bash

# Target dir
BIN_DIR=~/bin

if [ ! -d $BIN_DIR ]; then
    mkdir $BIN_DIR
fi

# Collect and install scripts in $BIN_DIR
# Don't overwrite if already there, but suggest manual install
find . \
| grep \.bash$ \
| xargs -i sh -c "\
    if [ ! -f $BIN_DIR/\$(basename {}) ]; then \
        cp {} $BIN_DIR; \
    else \
        echo {} already installed >&2; \
        echo you may use \'install-script {}\' instead >&2; \
        echo; \
    fi"

unset BIN_DIR
