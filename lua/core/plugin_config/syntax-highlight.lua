-- CONFIGURATION FOR SYNTAX HIGHLIGHTING
--------------------------------
-- nvim-treesitter only installs parsers and queries. highlighting itself is
-- nvim's builtin treesitter, started by the FileType autocmd below.

-- no-op for parsers that are already installed
require("nvim-treesitter").install({
	"bash",
	"c",
	"cpp",
	"dockerfile",
	"go",
	"html",
	"json", -- also covers jsonc
	"lua",
	"make",
	"markdown",
	"markdown_inline",
	"proto",
	"python",
	"ruby", -- Vagrantfile
	"rust",
	"toml",
	"vim",
	"yaml",
})

-- highlight any filetype that has a parser. the rest keep regex highlighting.
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})
