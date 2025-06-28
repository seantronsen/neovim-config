-- ease of use -- sanity -- pane motion without the tmux bullshit
vim.keymap.set({"n", "i"}, "<C-h>", function () vim.cmd("wincmd h") end, {desc="focus pane left"})
vim.keymap.set({"n", "i"}, "<C-j>", function () vim.cmd("wincmd j") end, {desc="focus pane down"})
vim.keymap.set({"n", "i"}, "<C-k>", function () vim.cmd("wincmd k") end, {desc="focus pane up"})
vim.keymap.set({"n", "i"}, "<C-l>", function () vim.cmd("wincmd l") end, {desc="focus pane right"})

-- NOTE: fixes pain point issue where <C-w> keybinding doesn't substitute-style
-- delete the word before the cursor while in insert mode inside a `prompt`
-- type buffer. according to the nvim docs here (accessed 10/01/2024):
-- <https://neovim.io/doc/user/channel.html#_5.-using-a-prompt-buffer>, the
-- maintainers have designed this as the default behavior within nvim. however,
-- I prefer consistency...
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
