-- lazy loaded: the snippet listing keymap is set at startup (init). luasnip
-- itself, its insert mode keymaps, and the snippet files load on the first
-- InsertEnter (config). see plugins.lua
local M = {}

function M.init()
	-- todo: create a telescope picker for this
	vim.keymap.set("n", "<leader>fs", function()
		local message = [[
		AVAILABLE LUASNIP SNIPPETS
		--------------------------

		]]
		vim.notify(message .. vim.inspect(require("luasnip").available()))
	end, { desc = "[l]ua[s]nip [a]vailable snippets" })
end

function M.config()
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

	require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
end

return M
