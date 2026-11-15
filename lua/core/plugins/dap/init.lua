-- lazy loaded: keymaps at startup (init), nvim-dap with its adapters and ui on
-- the first debug keymap (config). see plugins/init.lua
local M = {}

function M.init()
	require("core.plugins.dap.keymaps")
end

function M.config()
	require("core.plugins.dap.base")
	require("core.plugins.dap.adapters")
	require("core.plugins.dap.ui")
end

return M
