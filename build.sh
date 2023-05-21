#!/usr/bin/env bash

# Build and install rc files in $HOME
# Overwrite even if already there as all their sections are versioned controlled.
find $(readlink -f .) -type f \
| grep "manager\/build" \
| egrep "build-.+rc\.bash$" \
| xargs -i sh -c "echo Executing {}; {} > ~/.\$(basename {} | sed -E 's/build-(.+rc)\.bash/\1/')"
