-----------------------------
-- CONFIGURATION FOR TELESCOPE
-----------------------------
local action_layout = require("telescope.actions.layout")

require("telescope").setup({
	-- extensions = {
	-- 	fzf = {
	-- 		fuzz = true,
	-- 		override_generic_sorter = true,
	-- 		override_file_sorter = true,
	-- 		case_mode = "smart_case",
	-- 	},
	-- },
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
-- require("telescope").load_extension("fzf")
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
