#!/usr/bin/env bash

build-rc ${1:-_} bashrc $(find-script-dir ${BASH_SOURCE[0]})