-- lazy loaded: keymaps at startup (init), nvim-dap with its adapters and ui on
-- the first debug keymap (config). see plugins.lua
local M = {}

function M.init()
	require("core.plugin_config.dap.keymaps")
end

function M.config()
	require("core.plugin_config.dap.base")
	require("core.plugin_config.dap.adapters")
	require("core.plugin_config.dap.ui")
end

return M
