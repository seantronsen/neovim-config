------------------------------------------
-- BASIC CONFIGURATION FOR DAP
------------------------------------------
local dap = require("dap")

-- SUPPORT LAUNCH.JSON FILES
------------------------------------------
-- read ./.launch.json (launch.json format) from the cwd on each `,dc`. its
-- configs are listed for every filetype
dap.providers.configs["dap.launch.json"] = nil -- don't read ./.vscode/launch.json
dap.providers.configs["core.launch.json"] = function()
	return require("dap.ext.vscode").getconfigs(vim.fn.getcwd() .. "/.launch.json")
end

-- the current line marker. the other signs (B, C, L, R) are ascii already
vim.fn.sign_define("DapStopped", { text = "->" })

-- SETUP VIRTUAL TEXT
------------------------------------------
require("nvim-dap-virtual-text").setup({})
