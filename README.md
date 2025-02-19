# neovim-config

**this document is extremely out of date**

Simple backup of the neovim config used for writing code within unix-like
terminals. Currently using this toolset for writing source code based in Rust,
C, C++, and Python.

As for how to actually use the tooling, view a list of currently installed
plugins within `plugins.lua` and visit the docs of the associated projects. It
should be possible to find most of that information using nvims `:help
[item-name]` command. More detailed information can also be found within the
'LOCAL ADDITIONS' section at the bottom of the buffer after executing `:help`.

## Syntax Highlighting and Code Editing

Proper syntax highlighting and IDE-like features must be installed on a
language-by-language basis. In the current working version much of it is
installed automatically, but for languages not included by default (those
outside my preferences) the features must be installed somewhat manually.

To perform a one-time installation, execute the following in command mode:

1. `:MasonInstall [language analyzer/parser/formatter]`
   a. Repeat as needed for each unique type of tool.
   b. Note that a list of all available tools can be found using the command
   `:Mason`
2. `:LspInstall [language name]`
   a. Language server protocol support -- **Important**
3. `:TSInstall [language name]`
   a. Treesitter syntax highlighting support

> To ensure automatic installation later on, add the appropriate language
> server to the table of auto installs in the `lsp-config.lua` file. At the
> time of writing, the configuration properties exist under the section for
> `mason.nvim`.

## Possible Installation Issues

### Multiple Parser Issues

Ensure the only parser directory used by neovim is the nvim-treesitter/parser
directory. Find and delete any conflicting directories via the command:
`:echo nvim_get_runtime_file('parser', v:true)`

Typically, this only occurs if more than a single installation exists globally
on all user `$PATH`'s (via `apt`, `snap`, etc.).

## Dependencies

- [neovim](https://github.com/neovim/neovim/releases) $\geq$ v0.9.4
- [find-fd](https://github.com/sharkdp/fd)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- luarocks -- see `:checkhealth` for more info
- python v3.*
- nodejs $\geq$ v18

## Build Dependencies

- [make](https://www.gnu.org/software/make/manual/make.html) $\geq$ v4
- [gcc](https://gcc.gnu.org/)
- [xzutils](https://tukaani.org/xz/)
- [zip](https://infozip.sourceforge.net/Zip.html)
- [python3](https://github.com/python/cpython)
- [wget](https://www.gnu.org/software/wget/)
- [git](https://git-scm.com/) $\geq$ v2
