-- CONFIGURATION FOR SYNTAX HIGHLIGHTING
--------------------------------
local path_parser = vim.fn.stdpath("data") .. "/parsers"
vim.opt.runtimepath:append(path_parser)

require("nvim-treesitter.configs").setup({
	parser_install_dir = path_parser,
	ensure_installed = {
		"bash",
		"c",
		"cpp",
		"dockerfile",
		"go",
		"html",
		"json",
		"jsonc",
		"lua",
		"make",
		"markdown",
		"markdown_inline",
		"python",
		"rust",
		"toml",
		"vim",
		"yaml",
	},
	auto_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "markdown", "latex" },
	},
})
