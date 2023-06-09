# Helper functions

Abstracting out common script operations.

## Scripts

### build-rc

Usage: `build-rc AVATAR rc_extension real/path/to/script/file`

`build-rc` orchestrates several scripts to finally output a fully fledged `rc` file content
(such as a custom `.bashrc` or a custom `.taskrc`). The type of the file is determined
by `$2` (rc_extension), whereas $3 helps find all source files used to build the `rc` file.

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

### make-auxiliary-files

Usage: `make-auxiliary-files AVATAR MAIN_DIR TMP_DEPS`

`MAIN_DIR` is the dir relative to which all relative paths are defined.
`TMP_DEPS`is the enumeration of all sourced file paths.

Builds auxiliary files in `$MAIN_DIR/../.tmp` named like `some_mangled_string.func`
and `some_mangled_string.tmp`. The `.func` files wrap functions calling each other
in the same order as all sourced files should be included, allowing to build
a concatenation order. The `.tmp` files contain the concatenated texts with the
sourcing statements removed.

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

### make-tmp-rc

Usage: `make-tmp-rc AVATAR MAIN_FILE TMP_FILE`

`MAIN_FILE` is the entry point index of all sourced files.
`TMP_FILE` is the generated RC file, such as `.bashrc` or `.taskrc`.

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

### preprocess-source-file

Usage: `preprocess-source-file FILE AVATAR MAIN_DIR`

`MAIN_DIR` is the dir relative to which all relative paths are defined.

Outputs FILE with all $AVATAR evaluated and sourcing statements replaced
with mangled strings built out of sourced file paths with MAIN_DIR prepended. 
