#!/bin/bash

# Start and stop time: hhmm, hh hours 0-23, mm minutes 0-59
startTime=800
stopTime=2300

# Idle time in seconds
INTERVAL=300

check_time_and_run() {
	tempTime=$1

	if ! [ $tempTime -ge $startTime -a $tempTime -lt $stopTime ]; then
		# Sleep time
		/sbin/shutdown -h now
	fi

	sleep $INTERVAL
}

while true; do
	check_time_and_run $(date +%k%M)
done
