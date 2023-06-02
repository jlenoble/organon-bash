#!/usr/bin/env bash

build-rc ${1:-_} tilixrc $(find-script-dir ${BASH_SOURCE[0]})
