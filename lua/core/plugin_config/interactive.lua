---------------------------------------
-- CONFIGURATION FOR INTERACTIVE REPLS
---------------------------------------

-- NOTE THAT VIM-SLIME AND VIM-SLIME-CELLS
-- ADD TWO TEXT OBJECT MAPPINGS
-- 1. |ac| current cell and header
-- 2. |ic| current cell only

local slime_config = function()
	vim.cmd("SlimeConfig")
end

local slime_cells_send_goto_next = function()
	vim.cmd("SlimeCellsSendAndGoToNext")
end

local slime_cells_next = function()
	vim.cmd("SlimeCellsNext")
end

local slime_cells_prev = function()
	vim.cmd("SlimeCellsPrev")
end


vim.keymap.set("n", "<leader>sc", slime_config, { desc = "[s]lime [c]onfig" })
vim.keymap.set("n", "<leader>ss", slime_cells_send_goto_next, { desc = "[s]lime [s]end cells and go to next" })
vim.keymap.set("n", "<leader>sn", slime_cells_next, { desc = "[s]lime cells [n]ext" })
vim.keymap.set("n", "<leader>sp", slime_cells_prev, { desc = "[s]lime cells [p]revious" })
