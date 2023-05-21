#!/usr/bin/env bash

set -e

VALID_ARGS=$(getopt -o s -- "$@")

# Abort if any invalid option is passed
if [[ $? -ne 0 ]]; then
    exit 1;
fi

valid_options=""

eval set -- "$VALID_ARGS"
while [ : ]; do
  case "$1" in
    s)
        shift
        valid_options="$valid_options -s"
        ;;
    --)
        shift;
        break;
        ;;
  esac
done

APT_DIR="$(find-script-dir ${BASH_SOURCE[0]})/../aptrc/apt"

for pkg in $@; do
    sudo apt-get $valid_options install $pkg

    rcfile=$APT_DIR/$pkg.aptrc

    # Only option is -s ("simulate"), so no-op if set,
    # so skip registering install if valid_options=-s
    if [ ! -f "$rcfile" ] && [ -z $valid_options ]; then
        echo "sudo apt-get install $pkg" > $rcfile
    fi
done


