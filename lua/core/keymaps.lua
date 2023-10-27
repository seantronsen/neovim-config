-- note taking
vim.keymap.set("n", "<leader>ol", function() vim.cmd("ObsidianFollowLink") end, { desc = "[o]bsidian follow [l]ink" })
vim.keymap.set("n", "<leader>fn", function() vim.cmd("ObsidianSearch") end, { desc = "[f]ind obsidian [n]ote (search vault)" })
vim.keymap.set("n", "<leader>ob", function() vim.cmd("ObsidianBacklinks") end, { desc = "[o]bsidian [b]acklinks" })
vim.keymap.set("n", "<leader>on", function()
	local result = vim.fn.input("Note name: ")
	if vim.fn.empty(result) == 1 then
		print("error: name cannot be empty")
	else
		vim.cmd("ObsidianNew " .. result)
	end
end, { desc = "[o]bsidian create [n]ew note" })

-- formatting
vim.keymap.set("n", "<leader>re", function() vim.cmd("Format") end, { desc = "[r]e[f]ormat" })
vim.keymap.set("n", "<leader>nh", function() vim.cmd("nohls") end, { desc = "[n]o [h]ighlight" })



local function source_compile()
	local packer = require("packer")
	local current_file = vim.api.nvim_buf_get_name(0)
	vim.cmd("write")
	vim.cmd("source " .. current_file)
	packer.compile(nil, nil)
end
vim.api.nvim_create_user_command("PackerCS", source_compile, {})

vim.keymap.set("n", "<leader>pc", function() vim.cmd("PackerCS") end, { desc = "[p]acker [c]ompile source" })
vim.keymap.set("n", "<leader>ps", function() vim.cmd("PackerSync") end, { desc = "[p]acker [s]ync" })
