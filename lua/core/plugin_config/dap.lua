-- RUST
-- the config can be found in the setup for the rust-tools.nvim plugin.
-- ---------------------
-- dap.adapters.lldb = {
-- 	type = "executable",
-- 	command = "/home/sean/bin/lldb",
-- 	name = "lldb",
-- }

local dap = require("dap")
local widgets = require("dap.ui.widgets")
require("dap-python").setup("$CONDA_PREFIX/bin/python")

-- DAPUI SETUP
local dapui = require("dapui")
dapui.setup({
	layouts = {
		{
			elements = {
				{
					id = "scopes",
					size = 0.25,
				},
				{
					id = "breakpoints",
					size = 0.25,
				},
				{
					id = "stacks",
					size = 0.25,
				},
				{
					id = "watches",
					size = 0.25,
				},
			},
			position = "left",
			size = 80,
		},
		{
			elements = {
				{
					id = "repl",
					size = 0.5,
				},
				{
					id = "console",
					size = 0.5,
				},
			},
			position = "bottom",
			size = 20,
		},
	},
})
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.after.event_breakpoint["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- KEYBINDINGS
vim.keymap.set("n", "<leader>dx", dapui.toggle, { desc = "[d]ap toggle [b]reakpoint" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[d]ap toggle [b]reakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "[d]ap [c]ontinue" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "[d]ap step [o]ver" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "[d]ap step [i]nto" })
vim.keymap.set("n", "<leader>dd", dap.down, { desc = "[d]ap travel [d]own the stack" })
vim.keymap.set("n", "<leader>du", dap.up, { desc = "[d]ap travel [u]p the stack" })
vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "[d]ap [r]epl" })
vim.keymap.set("n", "<leader>dh", widgets.hover, { desc = "[d]ap [h]over (see variables)" })
vim.keymap.set("n", "<leader>dc", function()
	widgets.centered_float(widgets.scopes)
end, { desc = "[d]ap s[c]ope" })
