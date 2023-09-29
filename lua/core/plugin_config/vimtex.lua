vim.cmd("filetype plugin on")
vim.cmd("syntax enable")
local in_mathzone = function()
	local is_mathzone = vim.fn["vimtex#syntax#in_mathzone"]() == 1
	print("is math zone: " .. tostring(is_mathzone))
	return is_mathzone
end

local markdown_math_toggle = function()
	local cft = vim.bo.filetype
	if cft == "markdown" then
		vim.cmd("TSDisable true")
		vim.cmd("set filetype=tex")
	elseif cft == "tex" then
		vim.cmd("TSEnable true")
		vim.cmd("set filetype=markdown")
	else
		print("filetype '" .. cft .. "' is not supported. markdown and tex files only.")
	end
end

vim.keymap.set("n", "<leader>mz", in_mathzone, { desc = "is [m]ath[z]one" })
vim.keymap.set("n", "<leader>mt", markdown_math_toggle, { desc = "[m]arkdown [m]ath [t]oggle" })


vim.g.vimtex_syntax_enabled = 0
vim.g.vimtex_syntax_conceal_disable = 1
