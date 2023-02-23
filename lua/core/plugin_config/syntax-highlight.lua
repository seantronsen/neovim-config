-- CONFIGURATION FOR SYNTAX HIGHLIGHTING
--------------------------------
-- fix the tree sitter install and runtime path directories
vim.opt.runtimepath:append("~/.local/share/nvim/packed/nvim-treesitter")
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"bash",
		"c",
		"cpp",
		"dockerfile",
		"help",
		"html",
		"json",
		"lua",
		"make",
		"markdown",
		"python",
		"rust",
		"toml",
		"vim",
		"yaml",
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	parser_install_dir = "~/.local/share/nvim/packed/nvim-treesitter",
})
