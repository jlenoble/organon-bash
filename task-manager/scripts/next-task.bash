#!/usr/bin/bash

active_matches=`task active 2>&1 | grep "No matches."`

if [ "$active_matches" == "No matches." ]; then
    text=`task rc.verbose: descr | head -n1`

    if [ ! -z "$text" ];  then
        task next limit:1
        speak "$text"
    else
        task
        speak "toutes les tâches ont été accomplies"
    fi
else
    task active
    if [ "$1" != "--mute_if_active_task" ]; then
        speak "il y a déjà une tâche active"
    fi
fi
