-- CONFIGURATION FOR AUTO-COMPLETE
--------------------------------
local cmp = require("cmp")

-- set value via CLI to toggle autocomplete
vim.g.cmp_autocomplete = true

cmp.setup({
	enabled = function()
		return vim.g.cmp_autocomplete
	end,
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<leader>c"] = cmp.mapping.complete(),
		["<leader>a"] = cmp.mapping.abort(),
		["<C-Space>"] = cmp.mapping.confirm({ select = true }),
		-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),

	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		-- { name = "nvim_lsp_signature_help" },
	}, { { name = "buffer" } }),
	completion = {
		keyword_length = 3,
	},
	performance = {
		throttle = 10,
	},
	-- TODO - write a command that toggles the behavior below.
	-- comment/uncomment the lines below to disable/enable autocomplete features
	-- preselect = cmp.PreselectMode,
	-- completion = { autocomplete = false }
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	enabled = true,
	sources = cmp.config.sources({ { name = "cmp_git" } }, { { name = "buffer" } }),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	enabled = true,
	mapping = cmp.mapping.preset.cmdline(),
	sources = { { name = "buffer" } },
	completion = { keyword_length = 0 },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	enabled = true,
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
	completion = { keyword_length = 0 },
})
