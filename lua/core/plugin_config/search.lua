-----------------------------
-- CONFIGURATION FOR TELESCOPE
-----------------------------
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
local builtin = require("telescope.builtin")

-- builtin.find_files({ hidden = true })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[f]ind [f]iles" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[f]ind with live [g]rep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[f]ind [b]uffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[f]ind [h]elp tags" })
vim.keymap.set("n", "<leader>fo", builtin.lsp_outgoing_calls, { desc = "[f]ind lsp [o]utgoing funcion calls" })
vim.keymap.set("n", "<leader>fi", builtin.lsp_incoming_calls, { desc = "[f]ind lsp [i]ncoming funcion calls" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[f]ind [k]eymaps" })
vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "[f]ind and execute [c]ommands" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[f]ind [d]iagnostics (code issues)" })
vim.keymap.set("n", "<leader>fm", builtin.man_pages, { desc = "[f]ind [m]an pages" })

-- bindings to search relative to the current buffer position
local path_picker_builder = function(builtin_func)
	return function()
		local target_dir
		if vim.bo.filetype == "oil" then
			target_dir = require("oil").get_current_dir()
		else
			target_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
		end
		print(target_dir)
		builtin_func({ cwd = target_dir })
	end
end

vim.keymap.set("n", "<leader>fpf", path_picker_builder(builtin.find_files), { desc = "find files (relative)" })
vim.keymap.set("n", "<leader>fpg", path_picker_builder(builtin.live_grep), { desc = "find with live grep (relative)" })
