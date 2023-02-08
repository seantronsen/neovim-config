-----------------------------
-- CONFIGURATION FOR DOCUMENT FORMATTING
-----------------------------

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		-- Formatter configurations for filetype "lua" go here
		-- and will be executed in order
		lua = { require("formatter.filetypes.lua").stylua },
		rust = { require("formatter.filetypes.rust").rustfmt },
		python = { require("formatter.filetypes.python").black },
		json = { require("formatter.filetypes.json").prettier },
		["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
	},
})
