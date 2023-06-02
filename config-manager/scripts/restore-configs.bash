#!/usr/bin/env bash

# Gnome config
build-gnomerc | dconf load /org/gnome/

# Tilix config
build-tilixrc | dconf load /com/gexperts/Tilix/

TILIX_DIR=$(find-script-dir ${BASH_SOURCE[0]})/../tilixrc

mkdir -p "/home/jason/.config/tilix"
cp "$TILIX_DIR/workspaces/task-workspace.json" "/home/jason/.config/tilix/"
