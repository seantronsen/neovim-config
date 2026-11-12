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

### Filetypes That Need a Modeline

Language servers only start for the filetypes they list. Neovim doesn't detect
these from the file name, so mark each file with a modeline in its first or
last 5 lines. For files you can't edit, run `:set ft=...` after opening
them instead.

| Files                                                  | Modeline                 | Enables                                |
| ------------------------------------------------------ | ------------------------ | -------------------------------------- |
| ansible playbooks, role tasks/handlers                 | `# vim: ft=yaml.ansible` | ansible language server + ansible-lint |
| systemd units outside a `systemd/` dir (e.g. in repos) | `# vim: ft=systemd`      | systemd language server, highlighting  |

Units under `/etc/systemd/` and `~/.config/systemd/` are already detected.

## Git Diffs

Diff views are a viewer layer on top of the git CLI (gitsigns.nvim plus a few
commands in `lua/core/plugin_config/git.lua`).

| Keys      | Command                          | Does                                                         |
| --------- | -------------------------------- | ------------------------------------------------------------ |
| `,vd`     | `:Gitsigns diffthis`             | split diff, working tree vs staged                           |
| `,vi`     | `:GitInline`                     | toggle inline diff (deleted lines in place) vs staged        |
| `,vI`     | `:GitInline <ref>`               | inline diff vs any ref, e.g. `main` (PR base) or `~3`        |
| `,vr`     | `:GitDiffRefs <left> <right> [path]` | split diff of two refs, current file unless a path is given |
| `,vc`     | `:GitDiffChars`                  | toggle character level highlights in splits                  |
| `,vx`     | `:GitDiffClose`                  | close the diff view, restoring the original file             |
| `,vb`     | `:GitBlame`                      | toggle blame panel                                           |
| `]c` `[c` |                                  | next/previous change, in splits and the inline view          |

In splits, the left side is the older version (removed text in red) and the
right side the newer one (added text in green). The statusline names each side
`<ref>:<path>`, preferring a tag, then a branch, then a short commit sha. The
staged version is labelled `staged:`.

## Runtime Dependencies

- [neovim](https://github.com/neovim/neovim/releases) $\geq$ v0.12.5
- [find-fd](https://github.com/sharkdp/fd)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- python v3.\* with the `venv` module (`python3-venv` on Debian/Ubuntu), which
  mason needs for python based tools
- nodejs $\geq$ v18

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
