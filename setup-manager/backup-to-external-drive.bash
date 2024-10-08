#!/usr/bin/env bash

source strict-mode

MEDIA_DIR=/media/$USER
EXT_DRIVE=T7
BACKUP_DIR=BackUp
BACKUP_PATH="$MEDIA_DIR/$EXT_DRIVE/$BACKUP_DIR"
RSYNC_RELPATH=/home/.

backedupfiles=~/Documents/saved-files.txt
logfile=~/logs/backup-to-external-drive.log

(
	echo ">>>>> Start BackUp at $(date +"%Y/%m/%d %H:%M:%S %Z")"

	if [ -d "$MEDIA_DIR" ] && [ -d "$MEDIA_DIR/$EXT_DRIVE" ]; then
		if [ ! -d "$BACKUP_PATH" ]; then
			mkdir "$BACKUP_PATH"
		fi

		while IFS='' read -r line; do
			line=$(echo $line | xargs)

			if [[ -z $line ]] || [[ ${line:0:1} == '#' ]]; then
				echo "Skipping line: $line"
			else
				rsync -avR "$RSYNC_RELPATH/$line" "$BACKUP_PATH"
			fi

		done <"$backedupfiles"

	else
		echo "External drive is not mounted"
	fi

	echo ">>>>> End BackUp at $(date +"%Y/%m/%d %H:%M:%S %Z")"
) | tee -a "$logfile"

unset MEDIA_DIR EXT_DRIVE BACKUP_DIR BACKUP_PATH RSYNC_RELPATH backedupfiles logfile
