-- RUST
-- the config can be found in the setup for the rust-tools.nvim plugin.
-- ---------------------
-- dap.adapters.lldb = {
-- 	type = "executable",
-- 	command = "/home/sean/.vscode/extensions/vadimcn.vscode-lldb-1.8.1/lldb/bin/lldb",
-- 	name = "lldb",
-- }

local dap = require("dap")
local widgets = require("dap.ui.widgets")
-- dap.listeners.after.event_initialized["dapui_config"] = function()
-- 	dapui.open()
-- end
-- dap.listeners.after.event_breakpoint["dapui_config"] = function()
-- 	dapui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
-- 	dapui.close()
-- end
--
-- dap.listeners.before.event_exited["dapui_config"] = function()
-- 	dapui.close()
-- end
--
require("dap-python").setup("$CONDA_PREFIX/bin/python")

vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[d]ap toggle [b]reakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "[d]ap [c]ontinue" })
vim.keymap.set("n", "<leader>dso", dap.step_over, { desc = "[d]ap [s]tep [o]ver" })
vim.keymap.set("n", "<leader>dsi", dap.step_into, { desc = "[d]ap [s]tep [i]nto" })
vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "[d]ap [r]epl" })
vim.keymap.set("n", "<leader>dh", widgets.hover, { desc = "[d]ap [h]over (see variables)" })
vim.keymap.set("n", "<leader>dsc", function()
	widgets.centered_float(widgets.scopes)
end, { desc = "[d]ap [sc]ope" })
