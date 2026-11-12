-- local in_mathzone = function()
-- 	local is_mathzone = vim.fn["vimtex#syntax#in_mathzone"]() == 1
-- 	print("is math zone: " .. tostring(is_mathzone))
-- 	return is_mathzone
-- end

local markdown_math_toggle = function()
	local cft = vim.bo.filetype
	if cft == "markdown" then
		vim.treesitter.stop()
		vim.cmd("set filetype=tex")
	elseif cft == "tex" then
		-- treesitter restarts through the FileType autocmd in syntax-highlight.lua
		vim.cmd("set filetype=markdown")
	else
		print("filetype '" .. cft .. "' is not supported. markdown and tex files only.")
	end
end

-- vim.keymap.set("n", "<leader>mz", in_mathzone, { desc = "is [m]ath[z]one" })
vim.keymap.set("n", "<leader>mt", markdown_math_toggle, { desc = "[m]arkdown [m]ath [t]oggle" })

vim.keymap.set("n", "<leader>lv", function() vim.cmd("VimtexView") end, { desc = "[l]atex [v]iew" })
vim.keymap.set("n", "<leader>lc", function() vim.cmd("VimtexCompile") end, { desc = "[l]atex [c]ompile (sync)" })

vim.g.vimtex_syntax_enabled = 0
vim.g.vimtex_syntax_conceal_disable = 1
