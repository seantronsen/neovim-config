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
		-- NOTE: "markdown" was dropped from this list. under nvim 0.11 the regex
		-- syntax was cleared again after attach, so it never applied. nvim 0.12
		-- changes the ordering, which would turn it on for the first time.
		additional_vim_regex_highlighting = { "latex" },
	},
})
