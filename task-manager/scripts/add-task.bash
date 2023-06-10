#!/usr/bin/env bash

# Wrapper around task add that outputs the new task id

source strict-mode

echo $(task add $@) | grep -o -E '[0-9]+'
