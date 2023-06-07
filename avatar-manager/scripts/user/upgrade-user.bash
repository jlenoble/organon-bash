#!/usr/bin/env bash

user="$1"

if [ -z "$user" ] || ! [[ "$user" =~ ^[[:alpha:]][[:alnum:]]*$ ]]; then
    echo "Usage: $0 USER_IDENTIFIER" >&2
    exit 1
fi

user_in_passwd=$(grep "^$user" /etc/passwd)
user_in_home=$(\ls -A1 /home | grep "^$user$")

# Check user exists or invite to create it
if [ -z "$user_in_home" ] || [ -z "$user_in_passwd" ]; then
    if can-create-user-safely $user; then
        echo User "'$user'" is nowhere to be found. >&2
        echo Consider creating it first with: "'new-user $user'". >&2
    fi
    exit 1
fi

target_dir="/home/$user"

# Config SSH
if [ ! -d "$target_dir/.ssh" ]; then
    echo "- adding public key to new account"
    ssh-copy-id -i ~/.ssh/bookworm_id_rsa.pub $user@localhost
fi

# Config taskwarrior (prerequisite to fancy prompt)
if [ ! -f "$target_dir/.taskrc" ]; then
    echo "- testing connection with running 'task'"
    ssh -X $user@localhost task
fi

# Custom .bashrc
echo "- creating .bashrc"
build-bashrc $user >bashrc_content
scp bashrc_content $user@localhost:.bashrc
rm -f bashrc_content

# Custom .taskrc
echo "- creating .taskrc"
scp ~/.taskrc $user@localhost:

# Gnome
echo "- setting up Gnome"
build-gnomerc | ssh -X $user@localhost dconf load /org/gnome/

# Tilix
echo "- setting up Tilix"
build-tilixrc | ssh -X $user@localhost dconf load /com/gexperts/Tilix/
