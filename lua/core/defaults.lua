------------------------
-- DEFAULT SETTINGS
------------------------
vim.o.tabstop = 2
vim.o.softtabstop = 0
vim.g.expandtab = false
vim.o.shiftwidth = 2
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
vim.o.completeopt = "menu,menuone,noselect"
vim.o.number = true
vim.o.hlsearch = true
vim.o.showmatch = true
vim.o.mouse = "c"
vim.o.t_Co = 256
vim.cmd([[set termguicolors]])
vim.o.diffopt = "vertical"

------------------------
--  DISABLED
------------------------
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_julia_provider = 0

------------------------
--  VIM-SLIME
------------------------
vim.g.slime_target = "neovim"
vim.g.slime_no_mappings = 1
vim.g.slime_python_ipython = 1
vim.g.slime_cell_delimiter = "^\\s*# %%"
vim.g.slime_cells_no_highlight = 1
