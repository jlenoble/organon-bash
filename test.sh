#!/usr/bin/env bash

tests=$(find . | grep "__tests__/.*\.bats$")

for test in ${tests[@]}; do
    bats -F pretty "$test" | sed -e '/ ✓ /d' -e '/TASKRC override/d' -e '/TASKDATA override/d' | sed -Ee ':a;$!N;s/\n([0-9])/\1/;ta;P;D'
done
