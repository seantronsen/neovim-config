local luasnip = require("luasnip")
vim.keymap.set({ "i" }, "<C-S>", function()
	luasnip.expand()
end, { silent = true, desc = "snippet expand", noremap = true })
vim.keymap.set({ "i", "s" }, "<C-F>", function()
	luasnip.jump(1)
end, { silent = true, desc = "snippet forward", noremap = true })
vim.keymap.set({ "i", "s" }, "<C-B>", function()
	luasnip.jump(-1)
end, { silent = true, desc = "snippet backward", noremap = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
	if luasnip.choice_active() then
		luasnip.change_choice(1)
	end
end, { silent = true, desc = "snippet choice", noremap = true })

luasnip.config.set_config({

	history = true,
	update_events = "TextChanged,TextChangedI",
	store_selection_keys = "<C-S>",
	enable_autosnippets = true,
})

-- todo: create a jelescope picker for this
vim.keymap.set("n", "<leader>lsa", function()
	local message = [[
	AVAILABLE LUASNIP SNIPPETS
	--------------------------

	]]
	vim.notify(message .. vim.inspect(luasnip.available()))
end, { desc = "[l]ua[s]nip [a]vailable snippets" })

require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
require("luasnip.loaders.from_vscode").lazy_load() -- do I even need this line...?
