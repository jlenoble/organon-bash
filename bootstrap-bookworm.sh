#!/usr/bin/env bash

# After clean install, first configure Google Drive access via rclone.
# > sudo apt-get install rclone
# You will need to recover client ID, secret, password and salt to complete config.
# > sudo apt-get install keepass2
# Remotes are expected to be called GoogleDrive and GoogleDriveEncrypted.
# > rclone config

# Execute locally https://github.com/jlenoble/organon-bash/blob/main/bootstrap-bookworm.sh
# (this very file) to configure secure access to github and clone all bash scripts
if [ ! -d ~/Projets/organon-bash ]; then
	sudo apt-get install git

	rclone sync GoogleDriveEncrypted:BackUp/.gitconfig ~
	chmod 600 ~/.gitconfig

	rclone sync GoogleDriveEncrypted:BackUp/.ssh ~/.ssh
	chmod 700 ~/.ssh
	chmod 600 ~/.ssh/*

	mkdir -p ~/Projets
	cd ~/Projets
	git clone git@github.com:jlenoble/organon-bash
	cd ~
else
	echo "~/Projets/organon-bash already exists; git should already be installed and configured"
fi
