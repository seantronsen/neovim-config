-- CONFIGURATION FOR SYNTAX HIGHLIGHTING
--------------------------------
-- fix the tree sitter install and runtime path directories
vim.opt.runtimepath:append("~/.local/share/nvim/packed/nvim-treesitter")
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"cpp",
		"dockerfile",
		"lua",
		"vim",
		"python",
		"rust",
		"json",
		"html",
		"bash",
		"markdown",
		"make",
		"yaml",
		"toml",
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	parser_install_dir = "~/.local/share/nvim/packed/nvim-treesitter",
})
