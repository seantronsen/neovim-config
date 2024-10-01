-- formatting
vim.keymap.set("n", "<leader>re", function() vim.cmd("Format") end, { desc = "[r]e[f]ormat" })
vim.keymap.set("n", "<leader>nh", function() vim.cmd("nohls") end, { desc = "[n]o [h]ighlight" })

vim.keymap.set("n", "<leader>vv", function() vim.cmd("VimtexView") end, { desc = "[v]imtex [v]iew" })
vim.keymap.set("n", "<leader>vc", function() vim.cmd("VimtexCompile") end, { desc = "[v]imtex [c]ompile (sync)" })

-- note: fixes pain point issue where <C-w> keybinding doesn't substitute-style
-- delete the word before the cursor while in insert mode inside a `prompt`
-- type buffer. according to the nvim docs here (accessed 10/01/2024):
-- <https://neovim.io/doc/user/channel.html#_5.-using-a-prompt-buffer>, the
-- maintainers have designed this as the default behavior within nvim. however,
-- it's not for me as I prefer consistency. 
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		if vim.bo.buftype == "prompt" then
			vim.keymap.set(
				"i",
				"<C-w>",
				"<S-C-w>",
				{ noremap = true, silent = true, buffer = true }
			)
		end
	end,
})
