---@diagnostic disable: missing-fields
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
		completion = {
			border = cmp.config.window.bordered().border,
			scrollbar = true,
		},
		documentation = {
			border = cmp.config.window.bordered().border,
			max_height = 80,
			max_width = 80,
		},
	},
	mapping = cmp.mapping.preset.insert({
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-c>"] = cmp.mapping.complete(),
		["<C-a>"] = cmp.mapping.abort(),
		["<C-Space>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp", max_item_count = 50, priority = 100 },
		{ name = "nvim_lsp_signature_help", priority = 100 },
		{ name = "luasnip", priority = 0.001 },
	}),
	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			-- cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
	completion = {
		keyword_length = 2,
	},
	performance = {
		throttle = 0,
	},
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	enabled = true,
	sources = cmp.config.sources({ { name = "git" } }, { { name = "buffer" } }),
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

-- use dap as a source for debugging related completions
cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
	enabled = true,
	sources = {
		{ name = "dap" },
		{ name = "nvim_lsp_signature_help" },
	},
})
