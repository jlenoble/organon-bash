#!/usr/bin/env bash

# Print id of first task in context
echo $(task rc.verbose: idonly | head -n1 | xargs)
