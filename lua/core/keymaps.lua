-- formatting
vim.keymap.set("n", "<leader>re", function() vim.cmd("Format") end, { desc = "[r]e[f]ormat" })
vim.keymap.set("n", "<leader>nh", function() vim.cmd("nohls") end, { desc = "[n]o [h]ighlight" })
