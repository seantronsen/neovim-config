------------------------
-- DEFAULT SETTINGS
------------------------

vim.o.completeopt=menu,menuone,noselect
vim.opt.number=true
vim.o.mouse = c
vim.o.t_Co=256
vim.o.termguicolors = true

------------------------
--  DISABLED
------------------------
-- let g:loaded_python3_provider = 0
-- let g:loaded_node_provider = 0
-- let g:loaded_perl_provider = 0
vim.g.loaded_python3_provider = false
vim.g.loaded_node_provider = false
vim.g.loaded_perl_provider = false

------------------------
--  AUTO COMPLETE ON-DEMAND ONLY
--  TODO: is this actually doing anything?
------------------------
-- inoremap <C-x><C-o> <Cmd>lua require'cmp'.complete()<CR>


