------------------------
-- DEFAULT SETTINGS
------------------------
vim.g.mapleader = ","
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
vim.o.completeopt = menu, menuone, noselect
vim.o.number = true
vim.o.mouse = c
vim.o.t_Co = 256
vim.o.termguicolors = true

vim.o.diffopt = vertical

------------------------
--  DISABLED
------------------------
vim.g.loaded_python3_provider = false
vim.g.loaded_node_provider = false
vim.g.loaded_perl_provider = false
