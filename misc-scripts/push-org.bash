#!/usr/bin/env bash

cd ~/Projets/organon-bash
git checkout main
git merge dev
git push
git checkout dev
cd -
