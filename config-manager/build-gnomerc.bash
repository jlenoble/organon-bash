#!/usr/bin/env bash

build-rc ${1:-_} gnomerc $(find-script-dir ${BASH_SOURCE[0]})
