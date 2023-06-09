#!/usr/bin/env bash

# cf. http://redsymbol.net/articles/unofficial-bash-strict-mode/ for detailed explanations and workarounds.
#
# Summary:
# - The set -e option instructs bash to immediately exit if any command has a non-zero exit status.
set -e
# - set -u affects variables. When set, a reference to any variable you haven't previously defined - with the exceptions
#   of $* and $@ - is an error
set -u
# - set -o pipefail: This setting prevents errors in a pipeline from being masked.
set -o pipefail
# - The IFS variable - which stands for Internal Field Separator - controls what Bash calls word splitting.
IFS=$'\n\t'
