# Helper functions

Abstracting out common script operations.

## Scripts

### find-script-dir

A script may be run from anywhere but may rely on includes whose locations are only known
relative to its own location, such as `scriptdir/includes/file.inc`. Sourcing the latter
within `scriptdir/script` could be done naïvely with the line `. includes/file.inc`, but
this will generally fail unless the script is run from within the directory `scriptdir`.

Solution: Add the following two line inside the sourcing script:

```bash
SCRIPTDIR=$(find-script-dir ${BASH_SOURCE[0]})
. "$SCRIPTDIR/includes/file.inc"
```