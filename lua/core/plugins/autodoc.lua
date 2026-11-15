-- lazy loaded: keymaps at startup (init), neogen loads on first use (config).
-- see plugins/init.lua
local M = {}

-- generate a doc comment for the annotation type under the cursor
local function generate(type)
	return function()
		return require("neogen").generate({ type = type })
	end
end

function M.init()
	vim.keymap.set(
		"n",
		"<leader>cf",
		generate(nil),
		{ desc = "[c]omment [f]unction autodoc", noremap = true, silent = true }
	)
	vim.keymap.set(
		"n",
		"<leader>cc",
		generate("class"),
		{ desc = "[c]omment [c]lass autodoc", noremap = true, silent = true }
	)
	vim.keymap.set(
		"n",
		"<leader>ct",
		generate("type"),
		{ desc = "[c]omment [t]ype autodoc", noremap = true, silent = true }
	)
	vim.keymap.set(
		"n",
		"<leader>cb",
		generate("file"),
		{ desc = "[c]omment [b]uffer autodoc", noremap = true, silent = true }
	)
end

function M.config()
	require("neogen").setup({
		enabled = true,
		languages = {
			rust = {
				template = {
					annotation_convention = "rustdoc",
				},
			},
			python = {
				template = {
					annotation_convention = "reST",
				},
			},
		},
		-- todo: need to fix this at some point.
		-- snippet_engine = "luasnip", -- this breaks tree-sitter highlighting
	})
end

return M
