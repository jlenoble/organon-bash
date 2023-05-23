#!/usr/bin/env bash

# Crash right away if paths are not set
set -e

if [ -z $SPEAK_DIR ]; then
    echo "You must export SPEAK_DIR in your .bashrc" >&2
    exit 1
elif [ ! -d $SPEAK_DIR ]; then
    mkdir $SPEAK_DIR
fi

gain=0.12
rate=1.5

text=`cleanup-task-description "$1"`
file="$SPEAK_DIR/$text.mp3"

if [ ! -f "$file" ]; then
    gtts-cli "$text" -l fr --output "$file"
fi

#cvlc "$file" vlc://quit --gain=$gain --rate=$rate > /dev/null 2>&1
ffplay -nodisp -volume $(bc -l <<<"$gain*100") -af "atempo=$rate" -loglevel quiet -autoexit "$file"
