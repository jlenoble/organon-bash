#!/usr/bin/env bash

build-rc ${1:-_} taskrc $(find-script-dir ${BASH_SOURCE[0]})