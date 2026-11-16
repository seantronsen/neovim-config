# Docs

One page per topic.

| Page                               | Covers                                                              |
| ---------------------------------- | ------------------------------------------------------------------- |
| [languages.md](languages.md)       | adding a language (server, parser), filetypes that need a modeline  |
| [text-objects.md](text-objects.md) | treesitter text objects and function jumps                          |
| [git.md](git.md)                   | diff views, blame, jumping between changes                          |
| [debugging.md](debugging.md)       | adapters per language, keys, remote debugging, saved launch configs |

For everything else, the plugins are listed in `lua/core/plugins/init.lua` and
their docs are in `:help`. `,fh` searches the help pages, and `:help` lists the
installed plugins' pages under 'LOCAL ADDITIONS' at the bottom.
