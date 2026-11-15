-- lazy loaded on tex (see plugins/init.lua). everything here is set at
-- startup (init): vimtex reads its vim.g options when it loads
local M = {}

function M.init()
	vim.keymap.set("n", "<leader>lv", function() vim.cmd("VimtexView") end, { desc = "[l]atex [v]iew" })
	vim.keymap.set("n", "<leader>lc", function() vim.cmd("VimtexCompile") end, { desc = "[l]atex [c]ompile (sync)" })

	vim.g.vimtex_syntax_enabled = 0
	vim.g.vimtex_syntax_conceal_disable = 1
end

return M
