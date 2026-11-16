# Debugging

[Back to docs](README.md)

nvim-dap with nvim-dap-view as the UI (`lua/core/plugins/dap/`). Adapters come
from mason. Set a breakpoint with `,db`, start with `,dc` and pick a config. The
view opens on the left when the session starts and closes when it ends.

| Language | Adapter  | Configs (`,dc`)                                                                           |
| -------- | -------- | ----------------------------------------------------------------------------------------- |
| C / C++  | codelldb | `Launch executable` (prompts for the binary), `Attach to process`, `Connect to gdbserver` |
| Rust     | codelldb | the same, the prompt starting at `target/debug/`. run `cargo build` first                 |
| Go       | delve    | `Debug package`, `Debug file`, `Debug package tests`                                      |
| Python   | debugpy  | nvim-dap-python's: `file`, `file:args`, `attach`, `file:doctest`                          |

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

C, C++, and Rust binaries need debug info (`-g -O0`, or a cargo debug build).
delve refuses programs built with a Go older than it supports.

## Remote (C, C++, Rust)

With `Connect to gdbserver`:

1. on the remote host: `gdbserver :2345 ./prog` (or `gdbserver --attach :2345 <pid>`)
2. locally: `,dc`, `Connect to gdbserver`, answer the prompts (`host:2345`, and
   a local copy of the same binary, which is where the symbols come from)
3. it stops on entry. `,dc` again to run to the breakpoints

Built in a different directory over there? Breakpoints won't bind until the
config has `sourceMap = { ["/remote/src"] = "/local/src" }`.

Pointers show the value they point at. To see a malloc'd array, add a watch
(`W`, then `i`) like `ptr,[n]`, e.g. `heap,[3]`.

## Saved Launch Configs (`.launch.json`)

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

Breakpoints and watches don't survive restarting nvim.
