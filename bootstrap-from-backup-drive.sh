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
	echo "You must specify as first arg the device to be mounted (e.g. /dev/sdc1).
	You should find it among the devices below or it may not be plugged, or if working with WSL2
	you must first expose the drive using Powershell (open this script for detailed instructions)" 1>&2

	# Help find the external drive
	lsblk

	# sdc      8:32   0 931.5G  0 disk
	# └─sdc1   8:33   0 931.5G  0 part

	# Now bail out
	exit 1
fi

MEDIA_DIR=/media/$USER
EXT_DRIVE_NAME=T7
BACKUP_DIR_NAME=BackUp
BACKUP_DRIVE_PATH="$MEDIA_DIR/$EXT_DRIVE_NAME"
BACKUP_PATH="$BACKUP_DRIVE_DIR/$BACKUP_DIR_NAME"

# Make sure the dir for the drive mount exists
sudo mkdir -p "$BACKUP_DRIVE_PATH"

# Make the system up-to-date
sudo apt update
sudo apt upgrade

# Add required packages
sudo apt install cryptsetup git openssh-client

# Unlock the LUKS encryption
sudo cryptsetup open "$MOUNTDRIVE" luks-drive

# Mount the ext4 partition
sudo mount /dev/mapper/luks-drive "$BACKUP_DRIVE_PATH"

# Recover ssh public keys
cp -r "$BACKUP_PATH/$USER/.ssh/" ~/
chmod 700 .ssh

# Recover git config
cp -r "$BACKUP_PATH/$USER/.gitconfig" ~/
chmod 600 .gitconfig

# Clone organon-bash
mkdir -p ~/Projets
cd ~/Projets
git clone git@github.com:jlenoble/organon-bash.git

# Setup environment (will need to open a new bash after install for scripts to be found, and again for new .bashrc to be taken into account)
cd ~/Projets/organon-bash
./install.sh
./build.sh
