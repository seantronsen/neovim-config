local dap = require("dap")
require("dap-python").setup("~/$CONDA_PREFIX/bin/python")

vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[d]ap toggle [b]reakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "[d]ap [c]ontinue" })
vim.keymap.set("n", "<leader>dso", dap.step_over, { desc = "[d]ap [s]tep [o]ver" })
vim.keymap.set("n", "<leader>dsi", dap.step_into, { desc = "[d]ap [s]tep [i]nto" })
vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "[d]ap [r]epl" })

-- RUST
-- the config can be found in the setup for the rust-tools.nvim plugin.
-- ---------------------
-- dap.adapters.lldb = {
-- 	type = "executable",
-- 	command = "/home/sean/.vscode/extensions/vadimcn.vscode-lldb-1.8.1/lldb/bin/lldb",
-- 	name = "lldb",
-- }
