--------------------------------
-- A NVIM FILE EXPLORER
--------------------------------
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup({
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
})

vim.keymap.set("n", "<leader>t", ":NvimTreeFindFileToggle<CR>", { desc = "[t]ree (File Tree)" })

require("oil").setup()
vim.keymap.set("n", "<leader>de", "<CMD>Oil<CR>", { desc = "[d]irectory [e]dit" })
