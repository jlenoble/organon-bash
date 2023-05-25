#!/usr/bin/env bash

tests=$(find . | grep "__tests__/.*\.bats$" )

for test in ${tests[@]}; do
    # bats -F pretty "$test" | sed -e '/ ✓ /d' | sed -Ee ':a;$!N;s/\n([0-9])/\1/;ta;P;D'
    bats "$test"
done
