require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "carbonfox",
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
