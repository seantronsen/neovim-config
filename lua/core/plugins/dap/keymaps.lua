-- KEYBINDINGS DAP
------------------------------------------
-- set at startup. each binding loads nvim-dap (and its config) on first use.
vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end, { desc = "[d]ap [c]ontinue (or start)" })
vim.keymap.set("n", "<leader>ds", function() require("dap").terminate() end, { desc = "[d]ap [s]top (terminate)" })
vim.keymap.set("n", "<leader>dn", function() require("dap").step_over() end, { desc = "[d]ap step [n]ext (step over)" })
vim.keymap.set("n", "<leader>do", function() require("dap").step_out() end, { desc = "[d]ap step [o]ut" })
vim.keymap.set("n", "<leader>di", function() require("dap").step_into() end, { desc = "[d]ap step [i]nto" })
vim.keymap.set("n", "<leader>dt", function() require("dap").run_to_cursor() end, { desc = "[d]ap run [t]o cursor" })
vim.keymap.set("n", "<leader>dd", function() require("dap").down() end, { desc = "[d]ap travel [d]own the stack" })
vim.keymap.set("n", "<leader>du", function() require("dap").up() end, { desc = "[d]ap travel [u]p the stack" })
vim.keymap.set(
	"n",
	"<leader>db",
	function() require("dap").toggle_breakpoint() end,
	{ desc = "[d]ap toggle [b]reakpoint" }
)

-- KEYBINDINGS DAP-VIEW
------------------------------------------
-- loads nvim-dap first so dap-view is configured before it's toggled
vim.keymap.set("n", "<leader>dx", function()
	require("dap")
	require("dap-view").toggle()
end, { desc = "[d]ap toggle UI" })
