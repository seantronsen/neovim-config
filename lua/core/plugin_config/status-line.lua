require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = "auto",
		component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
	},
	sections = {
		lualine_c = {
			{
				"filename",
				path = 1,
			},
		},
	},
})
require("fidget").setup({})
