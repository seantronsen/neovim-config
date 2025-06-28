# neovim-config

Simple backup of the `nvim` config used for writing code within `*nix`
terminals.

As for how to actually use the tooling, view a list of currently installed
plugins within `plugins.lua` and visit the docs of the associated projects. It
should be possible to find most of that information using nvims
`:help [item-name]` command. There's also a helpful `,fh` keybinding which
spawns an interactive search over the same help pages.

Detailed information can also be found within the 'LOCAL ADDITIONS' section at
the bottom of the buffer after executing `:help`.

## Syntax Highlighting and Code Editing

Proper syntax highlighting and IDE-like features must be installed on a
language-by-language basis. In the current working version, much of the tooling
is installed automatically, but for languages not included by default (those
outside my preferences) the kit must be installed manually.

To perform a one-time installation, execute `:Mason` and use the built-in UI to
download the relevant language server. If necessary, specify additional settings
for that server in `lua/core/plugin_config/lsp.lua`. For better syntax
highlighting, install the treesitter grammar for the target language using
`:TSInstall <lang-name>`.

## Runtime Dependencies

- [neovim](https://github.com/neovim/neovim/releases) $\geq$ v0.11.2
- [find-fd](https://github.com/sharkdp/fd)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- python v3.\*
- nodejs $\geq$ v18

> The `Makefile` based installer will handle everything except for the
> installation of `python3`. Almost all modern `*nix` systems come with such an
> installation, so for brevity that one's been left out.

## Build Dependencies

- [make](https://www.gnu.org/software/make/manual/make.html) $\geq$ v4
- [gcc](https://gcc.gnu.org/)
- [xzutils](https://tukaani.org/xz/)
- [zip](https://infozip.sourceforge.net/Zip.html)
- [python3](https://github.com/python/cpython)
- [wget](https://www.gnu.org/software/wget/)
- [git](https://git-scm.com/) $\geq$ v2
