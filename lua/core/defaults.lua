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
vim.o.t_Co = 256 -- todo: fixme: this is invalid in nvim version 10+
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
-- vim.g.slime_target = "neovim"
-- vim.g.slime_no_mappings = 1
-- vim.g.slime_python_ipython = 1
-- vim.g.slime_cell_delimiter = "^\\s*# %%"
-- vim.g.slime_cells_no_highlight = 1

------------------------
--  VIMTEX
------------------------
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_quickfix_open_on_warning = 0

------------------------
--  VIM-DOGE
------------------------
vim.g.doge_enable_mappings = 0
vim.g.doge_doc_standard_python = "reST"
vim.g.doge_doc_standard_rust = "rustdoc"
vim.g.doge_doc_standard_sh = "google"
vim.g.doge_doc_standard_lua = "ldoc"
vim.g.doge_install_path = vim.fn.stdpath("data") .. "/autodoc/doge"
