# neovim-config

Simple backup of the `nvim` config used for writing code within `*nix`
terminals.

As for how to actually use the tooling, view a list of currently installed
plugins within `lua/core/plugins/init.lua` and visit the docs of the associated
projects. It should be possible to find most of that information using nvims
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
for that server in `lua/core/plugins/lsp.lua`. For better syntax
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
commands in `lua/core/plugins/git.lua`).

| Keys      | Command                              | Does                                                        |
| --------- | ------------------------------------ | ----------------------------------------------------------- |
| `,vd`     | `:Gitsigns diffthis`                 | split diff, working tree vs staged                          |
| `,vi`     | `:GitInline`                         | toggle inline diff (deleted lines in place) vs staged       |
| `,vI`     | `:GitInline <ref>`                   | inline diff vs any ref, e.g. `main` (PR base) or `~3`       |
| `,vr`     | `:GitDiffRefs <left> <right> [path]` | split diff of two refs, current file unless a path is given |
| `,vc`     | `:GitDiffChars`                      | toggle character level highlights in splits                 |
| `,vx`     | `:GitDiffClose`                      | close the diff view, restoring the original file            |
| `,vb`     | `:GitBlame`                          | toggle blame panel                                          |
| `]c` `[c` |                                      | next/previous change, in splits and the inline view         |

In splits, the left side is the older version (removed text in red) and the
right side the newer one (added text in green). The statusline names each side
`<ref>:<path>`, preferring a tag, then a branch, then a short commit sha. The
staged version is labelled `staged:`.

## Debugging

nvim-dap with nvim-dap-view as the UI (`lua/core/plugins/dap/`). Adapters come
from mason. Set a breakpoint with `,db`, start with `,dc` and pick a config. The
view opens on the left when the session starts and closes when it ends.

| Language | Adapter  | Configs (`,dc`)                                                                           |
| -------- | -------- | ----------------------------------------------------------------------------------------- |
| C / C++  | codelldb | `Launch executable` (prompts for the binary), `Attach to process`, `Connect to gdbserver` |
| Rust     | codelldb | the same, the prompt starting at `target/debug/`. run `cargo build` first                 |
| Go       | delve    | `Debug package`, `Debug file`, `Debug package tests`                                      |
| Python   | debugpy  | nvim-dap-python's: `file`, `file:args`, `attach`, `file:doctest`                          |

C, C++, and Rust binaries need debug info (`-g -O0`, or a cargo debug build).
delve refuses programs built with a Go older than it supports.

Remote (C, C++, Rust), with `Connect to gdbserver`:

1. on the remote host: `gdbserver :2345 ./prog` (or `gdbserver --attach :2345 <pid>`)
2. locally: `,dc`, `Connect to gdbserver`, answer the prompts (`host:2345`, and
   a local copy of the same binary, which is where the symbols come from)
3. it stops on entry. `,dc` again to run to the breakpoints

Built in a different directory over there? Breakpoints won't bind until the
config has `sourceMap = { ["/remote/src"] = "/local/src" }`.

Pointers show the value they point at. To see a malloc'd array, add a watch
(`W`, then `i`) like `ptr,[n]`, e.g. `heap,[3]`.

### Saved launch configs (`.launch.json`)

For launches you'd otherwise type into prompts every time. Put `.launch.json`
in the directory nvim was started from. It's read on every `,dc` (no restart
after edits) and its entries are listed first. Plain JSON: no trailing commas,
`//` comments only on their own line.

```json
{
  "configurations": [
    {
      "name": "c: args, env, cwd",
      "type": "codelldb",
      "request": "launch",
      "program": "${workspaceFolder}/build/main",
      "args": ["--verbose", "two words", "${env:USER}"],
      "env": { "MODE": "fast" },
      "cwd": "${workspaceFolder}/data"
    },
    {
      "name": "c: ask each time",
      "type": "codelldb",
      "request": "launch",
      "program": "${workspaceFolder}/build/main",
      "args": ["${input:file}"],
      "env": { "MODE": "${input:mode}" }
    },
    {
      "name": "go: one test",
      "type": "delve",
      "request": "launch",
      "mode": "test",
      "program": "${workspaceFolder}/pkg/store",
      "args": ["-test.run", "^TestSave$"]
    }
  ],
  "inputs": [
    {
      "id": "file",
      "type": "promptString",
      "description": "File: ",
      "default": "in.txt"
    },
    {
      "id": "mode",
      "type": "pickString",
      "description": "Mode",
      "options": ["fast", "slow"]
    }
  ]
}
```

Every entry needs `name`, `type` (the adapter) and `request` (`launch` or
`attach`). Common fields: `args` (a list, one item per argument), `env`, `cwd`.

Per adapter:

- `codelldb`: `program`, `stopOnEntry`, `sourceLanguages: ["rust"]` (Rust
  pretty-printers), `sourceMap`. Attach: `"pid": "${command:pickProcess}"`.
  Remote: `targetCreateCommands` + `processCreateCommands` (see
  `dap/adapters.lua`)
- `delve`: `program` (a package dir or a file), `mode` (`debug` default,
  `test`, `exec` for a prebuilt binary), `buildFlags: "-tags=extra"`. Tests take
  `-test.*` args
- `debugpy`: `program` or `module` (like `python -m`), `justMyCode: false` to
  step into libraries, `python` (interpreter path)

Variables: `${workspaceFolder}` (the start dir), `${file}`, `${fileDirname}`,
`${fileBasenameNoExtension}`, `${env:NAME}`, `${command:pickProcess}`,
`${command:pickFile}`. `${input:id}` asks at launch, using an `inputs` entry of
type `promptString` (typed, with an optional `default`) or `pickString` (a menu
of `options`).

Breakpoints and watches don't survive restarting nvim (#60).

| Keys              | Does                         |
| ----------------- | ---------------------------- |
| `,db`             | toggle breakpoint            |
| `,dc`             | continue, or start a session |
| `,dn` `,di` `,do` | step over / into / out       |
| `,dt`             | run to cursor                |
| `,du` `,dd`       | up / down the stack          |
| `,ds`             | stop                         |
| `,dx`             | toggle the view              |

In the view, `S` `W` `B` `T` `E` `R` switch sections (scopes, watches,
breakpoints, threads, exceptions, repl) and `g?` lists the rest.

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
