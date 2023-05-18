# Environment Manager

Helper scripts to set up a `bash` shell environment. 

## Motivation

Writing a custom `.bashrc` becomes hard very quickly as configs pile up.
We want helper tools to streamline common tasks.

## Commands

After package install (see main [README.md](../README.md#install)), commands
should be callable from anywhere.

### build-bashrc

```bash
# Outputs the generated .bashrc from all snipets within $PROJECTS_DIR/organon-bash/env-manager
build-bashrc

# Replace current .bashrc
build-bashrc > ~/.bashrc
```