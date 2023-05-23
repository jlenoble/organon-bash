#!/usr/bin/env bash

echo "$1" | tr -s '[:space:]' | xargs -0 | tr '[:upper:]' '[:lower:]'
