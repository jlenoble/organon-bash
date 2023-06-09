#!/usr/bin/env bash

# Basic wrapper for `task` when entering disagreeable tasks.
# Their priorities should be boosted to prevent postponing
# them indefinitely.

task-autotag chore $@
