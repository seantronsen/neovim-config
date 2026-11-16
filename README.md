# neovim-config

Personal `nvim` config for coding in `*nix` terminals, plus a `Makefile` that
installs it (with nvim and its tools) on a new machine, including those without
an internet connection.

Usage docs: [docs/](docs/README.md).

## Install

```sh
make initialize   # downloads/builds into build/, then opens nvim once to install plugins and tools
make install      # installs into ~/.local/{bin,sources,share} and ~/.config
```

- `OVERWRITE_INSTALLATION=1`: replace an existing install
- `BUNDLE_ALL=1`: bundle every tool, for a host without internet (copy this
  directory, `build/` included, over and run `make install` there). Without it,
  fd, rg and node/npm already on the host are used instead of downloaded, and
  `build/` only works on that host
- `CONFIG_REPO_URL=https://github.com/seantronsen/neovim-config.git`: clone
  without a GitHub ssh key (the default is ssh)

`install` only links fd, rg and node/npm into `~/.local/bin` when they aren't
already on PATH. tree-sitter (build only) comes from the host when it's >=
0.26.1, else the host's cargo builds it, else a throwaway rust toolchain.

## Runtime Dependencies

- [neovim](https://github.com/neovim/neovim/releases) $\geq$ v0.12.5
- [find-fd](https://github.com/sharkdp/fd)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- python v3.\* with the `venv` module (`python3-venv` on Debian/Ubuntu), which
  mason needs for python based tools
- nodejs $\geq$ v18
- optional: [tree-sitter-cli](https://github.com/tree-sitter/tree-sitter) $\geq$
  v0.26.1 and a C compiler, only to install parsers beyond the bundled ones

> The `Makefile` based installer will handle everything except for the
> installation of `python3`. Almost all modern `*nix` systems come with such an
> installation, so for brevity that one's been left out.

## Build Dependencies

- [make](https://www.gnu.org/software/make/manual/make.html) $\geq$ v4
- [gcc](https://gcc.gnu.org/)
- [xzutils](https://tukaani.org/xz/)
- [zip](https://infozip.sourceforge.net/Zip.html)
- [python3](https://github.com/python/cpython) with the `venv` module
  (`python3-venv` on Debian/Ubuntu)
- [wget](https://www.gnu.org/software/wget/)
- [git](https://git-scm.com/) $\geq$ v2
