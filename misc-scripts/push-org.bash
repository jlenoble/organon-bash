#!/usr/bin/env bash

if [ -d ./.git ]; then
	git checkout main
	git merge dev
	git push
	git checkout dev
fi
