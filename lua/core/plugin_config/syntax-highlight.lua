-- CONFIGURATION FOR SYNTAX HIGHLIGHTING
--------------------------------
-- fix the tree sitter install and runtime path directories
local path_parser = vim.env.HOME .. "/.local/share/nvim/parsers/nvim-treesitter"
vim.opt.runtimepath:append(path_parser)
require("nvim-treesitter.configs").setup({
	ensure_installed = require("core.plugin_config.treesitter.treesitter-parsers"),
	sync_install = false,
	-- auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "markdown", "latex" },
	},

	-- disable = {"latex", "markdown"},
	--ignore_install = {"latex", "markdown"},

	-- todo: this should use the nvim vars like mason does
	parser_install_dir = path_parser,
})
