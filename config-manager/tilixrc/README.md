# Using Tilix

## Restoring Tilix config

After installing all scripts (see [main README](../../README.md)), just run:

```bash
restore-tilix-config
```

## Updating Tilix config

You must distinguish between _profiles_, _workspaces_ and _sessions_.

- A profile configures a single tile
- A workspace defines a persistent tile composition and is loaded via a session (`-s` flag followed by an absolute path)
- Sessions determine how many workspaces a window composes

### Profiles

By editing the profile of a tile or creating a new one, you automatically update the current dconf. The profile is therefore
persisted on the computer. To make the profile available across computers, you must update this repo.

First get the current confige by running `save-tilix-config`. The `config-manager/.tmp` folder will contain the new `tilix.conf`,
the full config for Tilix in text format.

Then copy/paste the new profile section in a `.tilixrc` file (this extension is important) under the directory `config-manager/tilixrc/profiles`. Look at already existing `.tilixrc` files for the expected structure. Don't forget to push on Github.

### Workspaces

A modification in the tile layout is not persisted unless explicitly saved in a `.json` file. Save it under the directory `config-manager/tilixrc/workspaces` to make it available across computers. Use the `-s` flag followed by the absolute path to a workspace file to use it within a session.
