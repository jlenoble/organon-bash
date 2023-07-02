#!/usr/bin/env bash

filename_regex='^[a-z]+\.asm$'

filename=$1

if ! [[ "$filename" =~ $filename_regex ]]; then
    echo "Argument \$1 '$filename' is invalid. Expected '[a-z]+.asm'" >&2
    exit 1
fi

basename=${filename%.*}

if [ -f "$filename" ]; then
    nasm -f bin "$filename" -o "$basename.bin" -l "$basename.list"
else
    echo "Missing file '$filename'" >&2
    exit 1
fi
