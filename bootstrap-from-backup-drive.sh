#!/usr/bin/env bash

# If installing on WSL2, do first under Powershell:
#
# # Clean up WSL Debian
# wsl --terminate Debian
# wsl --unregister Debian
#
# # Reinstall by simply opening the Debian profile in a terminal
#
# # Check if Windows sees the external backup drive
# wmic diskdrive list brief
#
# # Make sure WSL is off
# wsl --shutdown
#
# # Expose the external backup drive to WSL (admin rights required)
# Start-Process powershell -Verb runAs -ArgumentList "wsl --mount \\.\PHYSICALDRIVE2"

MOUNTDRIVE=$1

if [ -z "$MOUNTDRIVE" ]; then
	echo "You must specify as first arg the device to be mounted (e.g. /dev/sdc1)" 1>&2
	exit 1
fi

# Make the system up-to-date
sudo apt update
sudo apt upgrade

# Add required packages
sudo apt install cryptsetup git openssh-client

# Find the  external drive
lsblk

# sdc      8:32   0 931.5G  0 disk
# └─sdc1   8:33   0 931.5G  0 part

# Unlock the LUKS encryption
sudo cryptsetup open "$MOUNTDRIVE" luks-drive

# Mount the ext4 partition
sudo mkdir -p /mnt/backup_drive
sudo mount /dev/mapper/luks-drive /mnt/backup_drive

# Recover ssh public keys
cp -r /mnt/backup_drive/BackUp/jason/.ssh/ ~/
chmod 700 .ssh

# Recover git config
cp -r /mnt/backup_drive/BackUp/jason/.gitconfig ~/
chmod 600 .gitconfig

# Clone organon-bash
mkdir -p ~/Projets
cd ~/Projets
git clone git@github.com:jlenoble/organon-bash.git

# Setup environment (will need to open a new bash after install for scripts to be found, and again for new .bashrc to be taken into account)
cd ~/Projets/organon-bash
./install.sh
./build.sh
