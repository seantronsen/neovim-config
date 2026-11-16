# Languages

[Back to docs](README.md)

The languages in the config get their server, tools and parser installed
automatically. For another language:

1. **Server:** add a row to the `servers` table in `lua/core/plugins/lsp.lua`
   (`mason` package, `lsp` config name, `bin`). On the next start mason installs
   it and nvim enables it. A server installed only through `:Mason` doesn't
   start. Server settings go in the row's `config`.
2. **Parser:** add it to the install list in
   `lua/core/plugins/syntax-highlight.lua`. `:TSInstall <lang>` works too, but
   only on that machine. Installing a parser needs tree-sitter-cli (>= 0.26.1)
   and a C compiler. On a host installed from the airgap bundle, only the
   bundled parsers are available.

## Filetypes That Need a Modeline

Language servers only start for the filetypes they list. Neovim doesn't detect
these from the file name, so mark each file with a modeline in its first or
last 5 lines. For files you can't edit, run `:set ft=...` after opening them
instead.

| Files                                                  | Modeline                 | Enables                                |
| ------------------------------------------------------ | ------------------------ | -------------------------------------- |
| ansible playbooks, role tasks/handlers                 | `# vim: ft=yaml.ansible` | ansible language server + ansible-lint |
| systemd units outside a `systemd/` dir (e.g. in repos) | `# vim: ft=systemd`      | systemd language server, highlighting  |

Units under `/etc/systemd/` and `~/.config/systemd/` are already detected.
