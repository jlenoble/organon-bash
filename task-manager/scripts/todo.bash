#!/usr/bin/env bash

# Basic default wrapper for `task`.
#
# Usage:
#   todo [any number of valid task args that can follow the add `command`]
# Examples:
#   todo Go shopping
#   todo Fix bug +urgent due:today

task add $@ +todo
