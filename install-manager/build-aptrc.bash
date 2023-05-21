#!/usr/bin/env bash

build-rc ${1:-_} aptrc $(find-script-dir ${BASH_SOURCE[0]})