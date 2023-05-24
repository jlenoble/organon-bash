#!/usr/bin/env bash

# Error if user $1 found already in /etc/passwd as entry or /home as directory

name="$1"
name_in_passwd=$(grep "^$name" /etc/passwd)
name_in_home=$(\ls -A1 /home | grep "^$name$")

if [ ! -z "$name_in_home" ]; then
    echo "/home/$name already exists," >&2
    if [ -z "$name_in_passwd" ]; then
        echo "but user $name does not appear in /etc/passwd
you may decide to rename /home/$name and try again, but you might break something
or you could pick another name for the new user" >&2
        exit 1
    else
        echo "and user $name is already present in /etc/passwd.
You should pick a different name for the new user,
or maybe you have already created the right one,
then call instead: 'upgrade-user $name'" >&2
        exit 1
    fi
elif [ ! -z "$name_in_passwd" ]; then
        echo "user $name is already present in /etc/passwd
but /home/$name does not exist, tread with caution and fix this before going further" >&2
        exit 1
fi
