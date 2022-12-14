# neovim-config

Simple backup of the neovim config used for writing code within unix-like terminals. Currently using this toolset for writing source code based in Rust, C, and Python. Requires a few items to be installed on the target system:

- [neovim](https://github.com/neovim/neovim/releases) $\geq$ v0.8.*
- [sharkdp/fd -- find-fd](https://github.com/sharkdp/fd)
- nodejs $\geq$ v18.*
- BurntSushi/ripgrep (available on apt)
- Nerd Fonts -- Fira Code (Monospaced is preferred since it works with PuTTY)
- luarocks -- see `:checkhealth` for more info


Probably needs to be run in a bash terminal too. As for how to actually use this tooling, see which plugins are currently installed within the init.vim file and visit the docs of the associated projects. It should also be possible to find most of that information using vim/nvims `:help [item-name]` command. More detailed information can also be found within the 'LOCAL ADDITIONS' section after executing `:help`.

**Important**
Ensure that the only parser directory being used by neovim is the nvim-treesitter/parser directory. Find and delete any conflicting directories via the command:
`:echo nvim_get_runtime_file('parser', v:true)`


Lastly, in regards to the current code editing features, it is important to remember to install functionality for each language. No additional configuration is needed within the init.vim file, but to add a language to the editor you must perform the following commands:

1. `:MasonInstall [language analyzer/parser/formatter]`
	a. Repeat as needed for each unique type of tool. 
	b. Note that a list of all available tools can be found using the command `:Mason`
2. `:LspInstall [language name]`
	a. Language server protocol support -- **Important**
3. `:TSInstall [language name]`
	a. Treesitter syntax highlighting support


## Version Notes
1. There is currently an issue with simrat39/rust-tools.nvim that causes inlay hints to not function correctly. More information on that can be found in [issue #311](https://github.com/simrat39/rust-tools.nvim/issues/311). For the meantime, this config will be using the [kdarkhan fork](https://github.com/kdarkhan/rust-tools.nvim) which is one of the solutions recommended in the comments of issue #311. 
