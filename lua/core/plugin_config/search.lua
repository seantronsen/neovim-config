-----------------------------
-- CONFIGURATION FOR TELESCOPE
-----------------------------
local action_layout = require("telescope.actions.layout")

require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["?"] = action_layout.toggle_preview,
			},
		},
		preview = {
			hide_on_startup = true,
		},
	},
})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[f]ind [f]iles" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[f]ind with live [g]rep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[f]ind [b]uffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[f]ind [h]elp tags" })
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "[f]ind [o]old files" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[f]ind [k]eymaps" })
vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "[f]ind and execute [c]ommands" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[f]ind [d]iagnostics (code issues)" })
vim.keymap.set("n", "<leader>fm", builtin.man_pages, { desc = "[f]ind [m]an pages" })
