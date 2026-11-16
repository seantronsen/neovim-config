# Text Objects

[Back to docs](README.md)

Treesitter text objects, for any language with a parser (see
`lua/core/plugins/textobjects.lua`). Selections work with operators and in
visual mode, e.g. `daf`, `cia`, `vic`. From before the object on the line, they
jump forward to it.

| Keys      | Does                                           |
| --------- | ---------------------------------------------- |
| `af` `if` | function, around / inside                      |
| `ac` `ic` | class (struct in C, Rust, Go), around / inside |
| `aa` `ia` | argument / parameter, with / without its comma |
| `]f` `[f` | next / previous function start                 |
| `]F` `[F` | next / previous function end                   |
