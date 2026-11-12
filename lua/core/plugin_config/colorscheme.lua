--------------------------------
-- COLORSCHEME CONFIGUTATION
--------------------------------
-- diff colors from delta's default dark theme. carbonfox's are too dim to tell
-- apart. DiffTextDelete is not a builtin group: git.lua uses it for removed text
-- on the older side of diff splits. gitsigns' inline view uses the GitSigns ones.
require("nightfox").setup({
	groups = {
		carbonfox = {
			DiffAdd = { bg = "#002800" },
			DiffDelete = { bg = "#3f0001" },
			DiffChange = { bg = "#1d2533" },
			DiffText = { bg = "#2c4a75", style = "bold" },
			DiffTextAdd = { bg = "#006000", style = "bold" },
			DiffTextDelete = { bg = "#901011", style = "bold" },
			GitSignsAddPreview = { bg = "#002800" },
			GitSignsDeletePreview = { bg = "#3f0001" },
			GitSignsAddInline = { bg = "#006000", style = "bold" },
			GitSignsDeleteInline = { bg = "#901011", style = "bold" },
			GitSignsChangeInline = { bg = "#2c4a75", style = "bold" },
		},
	},
})
vim.cmd([[colorscheme carbonfox]])
