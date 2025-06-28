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
vim.o.mouse = "a"
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
--  VIMTEX
------------------------
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_quickfix_open_on_warning = 0
