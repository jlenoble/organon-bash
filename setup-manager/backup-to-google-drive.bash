#!/usr/bin/env bash

source strict-mode

BACKUP_PATH="GoogleDriveEncrypted:BackUp"
RCLONE_RELPATH=/home

backedupfiles=~/Documents/saved-files.txt
logfile=~/logs/backup-to-google-drive.log

(
	echo ">>>>> Start BackUp at $(date +"%Y/%m/%d %H:%M:%S %Z")"

	while IFS='' read -r line; do
		line=$(echo $line | xargs)

		if [[ -z $line ]] || [[ ${line:0:1} == '#' ]]; then
			echo "Skipping line: $line"
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

	echo ">>>>> End BackUp at $(date +"%Y/%m/%d %H:%M:%S %Z")"
) | tee -a "$logfile"

unset BACKUP_PATH RCLONE_RELPATH REL_DIR backedupfiles logfile
