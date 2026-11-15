-- KEYBINDINGS DAP
------------------------------------------
-- set at startup. each binding loads nvim-dap (and its config) on first use.

-- function from the dap module by name, loaded on first use
local function dap(name)
	return function() require("dap")[name]() end
end

vim.keymap.set("n", "<leader>db", dap("toggle_breakpoint"), { desc = "[d]ap toggle [b]reakpoint" })
vim.keymap.set("n", "<leader>dc", dap("continue"), { desc = "[d]ap [c]ontinue (or start)" })
vim.keymap.set("n", "<leader>ds", dap("terminate"), { desc = "[d]ap [s]top (terminate)" })
vim.keymap.set("n", "<leader>dn", dap("step_over"), { desc = "[d]ap step [n]ext (step over)" })
vim.keymap.set("n", "<leader>do", dap("step_out"), { desc = "[d]ap step [o]ut" })
vim.keymap.set("n", "<leader>di", dap("step_into"), { desc = "[d]ap step [i]nto" })
vim.keymap.set("n", "<leader>dt", dap("run_to_cursor"), { desc = "[d]ap run [t]o cursor" })
vim.keymap.set("n", "<leader>dd", dap("down"), { desc = "[d]ap travel [d]own the stack" })
vim.keymap.set("n", "<leader>du", dap("up"), { desc = "[d]ap travel [u]p the stack" })

-- KEYBINDINGS DAPUI
------------------------------------------
-- loads nvim-dap first so dapui is configured before it's toggled
vim.keymap.set("n", "<leader>dx", function()
	require("dap")
	require("dapui").toggle()
end, { desc = "[d]ap toggle UI" })
-- vim.keymap.set("n", "<leader>dr", open_dap_ui, { desc = "[d]ap [r]eset ui" })
