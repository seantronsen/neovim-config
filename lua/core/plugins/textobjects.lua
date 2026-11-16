-- treesitter text objects: select and jump by function, class, and parameter.
-- the queries ship with the plugin, the parsers come from syntax-highlight.lua.
-- keys avoid the ones nvim's own ftplugins map ([[ ]] [m ]m)

-- lazy loaded: keymaps at startup (init), the plugin on first use (config).
-- see plugins/init.lua
local M = {}

function M.init()
	-- SELECT (visual and operator-pending: vaf, dif, cia, ...)
	vim.keymap.set(
		{ "x", "o" },
		"af",
		function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects") end,
		{ desc = "[a]round [f]unction" }
	)
	vim.keymap.set(
		{ "x", "o" },
		"if",
		function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects") end,
		{ desc = "[i]nside [f]unction" }
	)
	vim.keymap.set(
		{ "x", "o" },
		"ac",
		function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects") end,
		{ desc = "[a]round [c]lass" }
	)
	vim.keymap.set(
		{ "x", "o" },
		"ic",
		function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects") end,
		{ desc = "[i]nside [c]lass" }
	)
	vim.keymap.set(
		{ "x", "o" },
		"aa",
		function() require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects") end,
		{ desc = "[a]round [a]rgument (with its comma)" }
	)
	vim.keymap.set(
		{ "x", "o" },
		"ia",
		function() require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects") end,
		{ desc = "[i]nside [a]rgument" }
	)

	-- MOVE (normal, visual, operator-pending)
	vim.keymap.set(
		{ "n", "x", "o" },
		"]f",
		function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects") end,
		{ desc = "next [f]unction start" }
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"[f",
		function() require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects") end,
		{ desc = "previous [f]unction start" }
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"]F",
		function() require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects") end,
		{ desc = "next [F]unction end" }
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"[F",
		function() require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects") end,
		{ desc = "previous [F]unction end" }
	)
end

function M.config()
	require("nvim-treesitter-textobjects").setup({
		select = {
			-- from before the object on the line, jump forward to it (like targets.vim)
			lookahead = true,
			-- whole lines for functions and classes, so `daf` leaves no blank stub
			selection_modes = {
				["@function.outer"] = "V",
				["@class.outer"] = "V",
			},
		},
		move = {
			-- jumps go in the jumplist (<C-o> back)
			set_jumps = true,
		},
	})
end

return M
