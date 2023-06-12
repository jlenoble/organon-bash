#!/usr/bin/env bash

name="$1"
parent_avatar=$(get-avatar)

if [ "$parent_avatar" = unknown ]; then
    echo Could not determine avatar >&2
    exit 1
fi

if can-create-user-safely "$name"; then
    echo "- creating user $name and home directory /home/$name"
    sudo useradd -s /bin/bash -d "/home/$name" -G "$parent_avatar" -m "$name" && sudo passwd "$name"
    sudo chmod 750 "/home/$name/"
    sudo usermod -a -G $name $parent_avatar

    upgrade-user "$name"
fi
