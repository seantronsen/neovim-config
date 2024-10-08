-- CONFIGURATION FOR SYNTAX HIGHLIGHTING
--------------------------------
-- fix the tree sitter install and runtime path directories

local is_headless = require("core.utils").is_running_in_headless_mode()

local path_parser = vim.env.HOME .. "/.local/share/nvim/parsers/nvim-treesitter"
vim.opt.runtimepath:append(path_parser)

require("nvim-treesitter.configs").setup({
	ensure_installed = is_headless and {}
		or require("core.plugin_config.treesitter.treesitter-parsers"),
	sync_install = is_headless,
	auto_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "markdown", "latex" },
	},

	-- disable = {"latex", "markdown"},
	--ignore_install = {"latex", "markdown"},

	-- todo: this should use the nvim vars like mason does
	parser_install_dir = path_parser,
})
