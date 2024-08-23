#!/usr/bin/env bash

source strict-mode

target=${1:-local}

case $target in
local)
    stem=backup-to-external-drive
    logfile=~/logs/$stem.log
    ;;
googleDrive)
    stem=backup-to-google-drive
    logfile=~/logs/$stem.log
    ;;
*)
    echo "Unknown argument $1; Expected 'local' or 'googleDrive'" 1>&2
    ;;
esac

if [ ! -f "$logfile" ]; then
    touch $logfile
fi

execute() {
    clear
    tail -n 60 -f $logfile | clog $stem
}

# Don't exit on first error
set +e

execute

unset stem target logfile
