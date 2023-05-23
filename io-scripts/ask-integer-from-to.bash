#!/usr/bin/env bash

re='^[0-9]+$'

if ! [[ $2 =~ $re ]]; then
    echo "'$2' is not an integer" >&2
    exit 1
elif ! [[ $3 =~ $re ]]; then
    echo "'$3' is not an integer" >&2
    exit 1
fi

question=$1
min=$2
max=$3

while true; do
    read -e -p "$question? (range:$min..$max) " pos

    if ! [[ $pos =~ $re ]]; then
        echo "'$pos' is not an integer" >&2
    elif [ $pos -lt $min ]; then
        echo "'$pos' is too small" >&2
    elif [ $pos -gt $max ]; then
        echo "'$pos' is too large" >&2
    else
        echo -n $pos
        exit
    fi
done
