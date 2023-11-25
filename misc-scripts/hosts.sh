#!/bin/bash

# Files
WORKSOURCE=/root/etc/hosts
LEISURESOURCE=/root/etc/hosts-head
TARGET=/etc/hosts

# Start and stop time: hhmm, hh hours 0-23, mm minutes 0-59
startTime=800
stopTime=2000
tempTime=$(date +%k%M)

# Idle time in seconds
INTERVAL=120

# Set initial time of file
if [ $tempTime -ge $startTime -a $tempTime -lt $stopTime ]; then
	cp $WORKSOURCE $TARGET
	FILE=$WORKSOURCE
else
	cp $LEISURESOURCE $TARGET
	FILE=$LEISURESOURCE
fi
LTIME=$(stat -c %y $TARGET)

check_time_and_run() {
	tempTime=$1
	MTIME=$(stat -c %y $TARGET)

	if [ $tempTime -ge $startTime -a $tempTime -lt $stopTime ]; then
		# Work time
		if [ "$MTIME" != "$LTIME" ] || [ "$FILE" != "$WORKSOURCE" ]; then
			DIFF=$(diff $WORKSOURCE $TARGET)

			if [[ "$DIFF" != "" ]]; then
				cp $WORKSOURCE $TARGET
				FILE=$WORKSOURCE
				MTIME=$(stat -c %y $TARGET)

				if pgrep -fa "chrome" >/dev/null; then
					kill $(pgrep -f chrome)
				fi

				if pgrep -fa "firefox" >/dev/null; then
					kill $(pgrep -f firefox)
				fi
			fi

			LTIME=$MTIME
		fi
	else
		# Leisure time
		if [ "$MTIME" != "$LTIME" ] || [ "$FILE" != "$LEISURESOURCE" ]; then
			DIFF=$(diff $LEISURESOURCE $TARGET)

			if [[ "$DIFF" != "" ]]; then
				cp $LEISURESOURCE $TARGET
				FILE=$LEISURESOURCE
				MTIME=$(stat -c %y $TARGET)

				if pgrep -fa "chrome" >/dev/null; then
					kill $(pgrep -f chrome)
				fi

				if pgrep -fa "firefox" >/dev/null; then
					kill $(pgrep -f firefox)
				fi
			fi

			LTIME=$MTIME
		fi
	fi

	sleep $INTERVAL
}

while true; do
	check_time_and_run $(date +%k%M)
done
