------------------------------------------
-- BASIC CONFIGURATION FOR DAP
------------------------------------------
local dap = require("dap")
-- dap.set_exception_breakpoints({ "raised", "uncaught" })
-- dap.defaults.fallback.exception_breakpoints = { "raised", "uncaught" }

-- SUPPORT LAUNCH.JSON FILES
------------------------------------------
local launch_path = vim.uv.cwd() .. "/.launch.json"
local launch_filetype_maps = {
	debugpy = { "python" },
	codelldb = { "c", "cpp" },
}

-- this method of config is deprecated as of Sat Jun 28 03:24:11 PM MDT 2025
-- however, the new batteries included method seems to mandate placing the
-- config in a `.vscode/.launch.json` file, which I'm not willing to conform
-- to.
require("dap.ext.vscode").load_launchjs(launch_path, launch_filetype_maps)

-- SETUP VIRTUAL TEXT
------------------------------------------
require("nvim-dap-virtual-text").setup({})
