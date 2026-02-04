------------------------
-- DEFAULT SETTINGS
------------------------
local tab_spaces = 4
vim.o.tabstop = tab_spaces
vim.o.softtabstop = tab_spaces
vim.o.expandtab = true
vim.o.shiftwidth = tab_spaces
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

-- synctex isn't applicable to macos installations unless one is willing to
-- undergo the setup process for DBUS on such systems. this process requires
-- elevated privileges and is especially troublesome on aarch64 type
-- processors.
-- for that reason, I'm choosing to forego the feature entirely when I'm stuck
-- on macos devices...
if vim.uv.os_uname().sysname == "Darwin" then
	-- vim.notify("macOS detected")
	vim.g.vimtex_view_zathura_use_synctex = 0
end
