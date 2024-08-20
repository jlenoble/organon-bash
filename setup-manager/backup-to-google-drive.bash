#!/usr/bin/env bash

source strict-mode

BACKUP_PATH="GoogleDriveEncrypted:BackUp"
RCLONE_RELPATH=/home

backedupfiles=~/Documents/saved-files.txt

while IFS='' read -r line; do
	line=$(echo $line | xargs)

	if [[ -z $line ]] || [[ ${line:0:1} == '#' ]]; then
		echo "Skipping line: $line" 1>&2
	else
		if [ -d "$RCLONE_RELPATH/$line" ]; then
			REL_DIR=$line
			rclone sync "$RCLONE_RELPATH/$REL_DIR" "$BACKUP_PATH/$REL_DIR" -vv
		else
			REL_DIR=$(dirname $line)
			rclone sync "$RCLONE_RELPATH/$line" "$BACKUP_PATH/$REL_DIR" -vv
		fi
	fi

done <"$backedupfiles"

unset BACKUP_PATH RCLONE_RELPATH REL_DIR backedupfiles
