-- note taking
vim.keymap.set("n", "<leader>ol", function() vim.cmd("ObsidianFollowLink") end, { desc = "[o]bsidian follow [l]ink" })
vim.keymap.set("n", "<leader>fn", function() vim.cmd("ObsidianSearch") end, { desc = "[f]ind obsidian [n]ote (search vault)" })
vim.keymap.set("n", "<leader>ob", function() vim.cmd("ObsidianBacklinks") end, { desc = "[o]bsidian [b]acklinks" })
vim.keymap.set("n", "<leader>on", function()
	local result = vim.fn.input("Note name: ")
	if vim.fn.empty(result) == 1 then
		print("name cannot be empty...")
	end
	vim.cmd("ObsidianNew " .. result)
end, { desc = "[o]bsidian create [n]ew note" })
