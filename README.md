# organon-bash

A collection of bash scripts

## Bootstrap

After a few manual steps explained within the script to set up rclone and git,
the script will clone this repo for future dev.

```bash
chmod a+x bootstrap-bookworm.sh
./bootstrap-bookworm.sh
```

## Install

Scripts are installed in `~/bin`. No overwrites are performed.

```bash
chmod a+x install.sh
./install.sh
```

## Build

To set up the environment after all packages are installed

```bash
chmod a+x build.sh
./build.sh
```
