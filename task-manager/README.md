# Task Manager

Helper scripts around `taskwarrior`

## Motivation

`taskwarrior` is a fairly low level (i.e. syntactically wordy) tool.
Wrapping common `taskwarrior` commands into `bash` scripts makes life
easier.

## Commands

After package install (see main [README.md](../README.md#install)), commands
should be callable from anywhere.

### build-taskrc

```bash
# Outputs the generated .taskrc from all snipets within $PROJECTS_DIR/organon-bash/env-manager
build-taskrc

# Replace current .taskrc
build-taskrc > ~/.taskrc
```
