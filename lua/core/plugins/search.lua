-----------------------------
-- CONFIGURATION FOR TELESCOPE
-----------------------------
-- lazy loaded: keymaps are set at startup (init) and telescope itself loads on
-- the first picker (config). see plugins/init.lua
local M = {}

-- picker by name from telescope.builtin, loaded on first use
local function picker(name, opts)
	return function()
		require("telescope.builtin")[name](opts)
	end
end

-- bindings to search relative to the current buffer position
local function relative_picker(name)
	return function()
		local target_dir
		if vim.bo.filetype == "oil" then
			target_dir = require("oil").get_current_dir()
		else
			target_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
		end
		print(target_dir)
		require("telescope.builtin")[name]({ cwd = target_dir })
	end
end

function M.init()
	vim.keymap.set("n", "<leader>ff", picker("find_files"), { desc = "[f]ind [f]iles" })
	vim.keymap.set("n", "<leader>fg", picker("live_grep"), { desc = "[f]ind with live [g]rep" })
	vim.keymap.set("n", "<leader>fb", picker("buffers"), { desc = "[f]ind [b]uffers" })
	vim.keymap.set("n", "<leader>fh", picker("help_tags"), { desc = "[f]ind [h]elp tags" })
	-- vim.keymap.set("n", "<leader>ffo", picker("lsp_outgoing_calls"), { desc = "[f]ind lsp [o]utgoing funcion calls" })
	-- vim.keymap.set("n", "<leader>ffi", picker("lsp_incoming_calls"), { desc = "[f]ind lsp [i]ncoming funcion calls" })
	vim.keymap.set("n", "<leader>fk", picker("keymaps"), { desc = "[f]ind [k]eymaps" })
	vim.keymap.set("n", "<leader>fc", picker("commands"), { desc = "[f]ind and execute [c]ommands" })
	vim.keymap.set("n", "<leader>fd", picker("diagnostics"), { desc = "[f]ind [d]iagnostics (code issues)" })
	vim.keymap.set("n", "<leader>fm", picker("man_pages"), { desc = "[f]ind [m]an pages" })

	vim.keymap.set("n", "<leader>fpf", relative_picker("find_files"), { desc = "find files (relative)" })
	vim.keymap.set("n", "<leader>fpg", relative_picker("live_grep"), { desc = "find with live grep (relative)" })
end

function M.config()
	local action_layout = require("telescope.actions.layout")
	require("telescope").setup({
		defaults = {
			mappings = {
				i = {
					-- disable tab select without allowing tab char input
					["<Tab>"] = function() end,
					["<S-Tab>"] = function() end,
					["?"] = action_layout.toggle_preview,
				},
				n = {
					-- disable tab select without allowing tab char input
					["<Tab>"] = function() end,
					["<S-Tab>"] = function() end,
				},
			},
			preview = {
				hide_on_startup = true,
			},
		},
	})
end

return M
