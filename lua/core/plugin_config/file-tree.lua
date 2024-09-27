--------------------------------
-- A NVIM FILE EXPLORER
--------------------------------
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- require("nvim-tree").setup({
-- 	actions = {
-- 		open_file = {
-- 			quit_on_open = true,
-- 		},
-- 	},
-- })
--
-- vim.keymap.set("n", "<leader>t", ":NvimTreeFindFileToggle<CR>", { desc = "[t]ree (File Tree)" })

require("oil").setup({
	keymaps = {
		["g?"] = "actions.show_help",
		["<CR>"] = "actions.select",
		["<C-s>"] = false,
		["<C-h>"] = false,
		["<C-t>"] = false,
		["<C-p>"] = false,
		["<C-c>"] = false,
		["<C-l>"] = false,
		["-"] = "actions.parent",
		["_"] = "actions.open_cwd",
		["`"] = "actions.cd",
		["~"] = "actions.tcd",
		["gs"] = "actions.change_sort",
		["gx"] = false,
		["g."] = "actions.toggle_hidden",
		["g\\"] = false,
	},
})
vim.keymap.set("n", "<leader>de", "<CMD>Oil<CR>", { desc = "[d]irectory [e]dit" })
