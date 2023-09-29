local ls = require("luasnip")
vim.keymap.set({ "i" }, "<C-S>", function()
	ls.expand()
end, { silent = true, desc = "snippet expand", noremap = true })
vim.keymap.set({ "i", "s" }, "<A-F>", function()
	ls.jump(1)
end, { silent = true, desc = "snippet forward", noremap = true })
vim.keymap.set({ "i", "s" }, "<C-B>", function()
	ls.jump(-1)
end, { silent = true, desc = "snippet backward", noremap = true })
vim.keymap.set({ "i", "s" }, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true, desc = "snippet choice", noremap = true })

ls.config.set_config({

	history = true,
	update_events = "TextChanged,TextChangedI",
	store_selection_keys = "<C-S>"
})

require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" })
require("luasnip.loaders.from_vscode").lazy_load()
