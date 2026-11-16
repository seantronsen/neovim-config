# Git

[Back to docs](README.md)

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
