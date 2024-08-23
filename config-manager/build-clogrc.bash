#!/usr/bin/env bash

build-rc ${1:-_} clogrc $(find-script-dir ${BASH_SOURCE[0]})
