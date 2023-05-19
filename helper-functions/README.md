# Helper functions

Abstracting out common script operations.

## Scripts

### collect-deps

Explore a file and its dependencies (in the form `. file_path` or `source file_path`)
and prints them all uniquely to screen.

```bash
collect-deps MAIN_FILE AVATAR
```

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

### get-avatar

```bash
# If BASHRC_DIR/avatars/USER.bashoption exists
get-avatar # $USER
get-avatar $USER # $USER
get-avatar my_defined_avatar # my_defined_avatar
get-avatar my_undefined_avatar # $USER
get-avatar root # root
get-avatar unknown # unknown
```

### make-index-file and make-index-files

A directory may contain an indeterminate number of files to source. Rather than rediscovering
them every time, create an index file that sources them all.

```bash
# dir contains f1.bashrc and f2.bashrc
make-index-file dir
# creates dir/index.bashrc with content:
# . dir/f1.bashrc
# . dir/f2.bashrc
```

`make-index-files` apply `make-index-file` recursively.

### mangle-name and unmangle-name

`mangle-name` outputs a *quasi* reversible identifier based on a FILE_PATH and an optional
RELATIVE_PATH (defaults to `pwd`). *Quasi* means that FILE_PATH may be restored
by `unmangle-path` to its original value or to an *equivalent* path.

Underneath, both scripts work with `realpath`, which ensures the unicity of the target file
by enforcing actual paths only (dir names must point to actual dirs, base names are free).

```bash
# Usage:
#   mangle-name FILE_PATH [RELATIVE_PATH]

cd # cwd is $HOME
echo $USER # I am jason

mangle-name ~/.bashrc # Outputs: _2bashrc
unmangle-name _2bashrc # Outputs: /home/jason/.bashrc

mangle-name ~/.bashrc / # Outputs: home_1jason_1_2bashrc
unmangle-name _2bashrc / # Outputs: /home/jason/.bashrc

mangle-name /etc/apt/source.list # Outputs: _2_2_1_2_2_1etc_1apt_1source_2list
unmangle-name _2_2_1_2_2_1etc_1apt_1source_2list # Outputs: /etc/apt/source.list

mangle-name /etc/apt/source.list / # Outputs: etc_1apt_1source_2list
unmangle-name etc_1apt_1source_2list / # Outputs: /etc/apt/source.list
```
