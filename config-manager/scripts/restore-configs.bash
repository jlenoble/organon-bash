#!/usr/bin/env bash

# Gnome config
build-gnomerc | dconf load /org/gnome/

GNOME_DIR=$(find-script-dir ${BASH_SOURCE[0]})/gnome

mkdir -p "/home/jason/.local/share/applications"
cp "$GNOME_DIR/quicklaunch-url.desktop" "/home/jason/.local/share/applications"
update-desktop-database /home/jason/.local/share/applications/
xdg-mime default quicklaunch-url.desktop x-scheme-handler/quicklaunch

# Tilix config
build-tilixrc | dconf load /com/gexperts/Tilix/

TILIX_DIR=$(find-script-dir ${BASH_SOURCE[0]})/../tilixrc

mkdir -p "/home/jason/.config/tilix"
cp "$TILIX_DIR/workspaces/task-workspace.json" "/home/jason/.config/tilix/"
