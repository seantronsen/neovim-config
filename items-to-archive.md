---
id: items-to-archive
aliases: []
tags: []
---

# packaging nvim for use without a network

## items to collect for local archiving

- [ ] nvim binaries
- [ ] submodules
- [ ] dotfiles
- [ ] plugins
- [ ] plugin installs (lsps and tree-sitter parsers)
- [ ] ripgrep
- [ ] fdfind
- [ ] nodejs (needed for pyright and several other mason installs)

## plugin that use the network

- [ ] mason
- [ ] possibly telescope
- [ ] possibly obsidian
- [ ] treesitter

> [!info] Note if we can figure out a way to: download nvim. launch nvim to
> trigger mason to download all these things. then we should almost be okay

## idea

general plan will be similar to the current auto installation setup.

- work on gutting out anything unecessary
- include nodejs archive in bundle
- include ripgrep and fd find in bundle

## workflow

1. download nvim appimage or prebuilt, whichever
2. unpack nvim app image
3. ibid, nodejs
4. ibid, ripgrep
5. ibid, fdfind
6. ibid, bash config
7. ibid, bash submodules (if needed. try to eliminate)
8. run a script that tosses necessities like node, npm, ripgrep, fd, into bash
   config if not already there, and adds to bundle script path
9. find a way to open nvim with a command so that mason and everyone else
   installs everything needed.
10. package nvim plugins and dependencies from .local/share/nvim into the bundle
11. package config from .config/nvim
