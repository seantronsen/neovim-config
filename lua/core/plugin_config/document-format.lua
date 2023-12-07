-----------------------------
-- CONFIGURATION FOR DOCUMENT FORMATTING
-----------------------------

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
local util = require("formatter.util")
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		-- programming languages
		c = { require("formatter.filetypes.c").clangformat },
		cpp = { require("formatter.filetypes.cpp").clangformat },
		cmake = { require("formatter.filetypes.cmake").cmakeformat },
		javascript = { require("formatter.filetypes.javascript").prettier },
		lua = { require("formatter.filetypes.lua").stylua },
		python = { require("formatter.filetypes.python").black },
		rust = { require("formatter.filetypes.rust").rustfmt },
		typescript = { require("formatter.filetypes.javascript").prettier },

		-- data languages
		sql = {
			function()
				local current_filename = util.get_current_buffer_file_path()
				local args = { "" .. " " .. "-" }
				return { exe = "sqlfmt", args = args, stdin = true }
			end,
		},

		-- scripting languages
		sh = { require("formatter.filetypes.sh").shfmt },

		-- object documents
		json = { require("formatter.filetypes.json").prettier },

		-- markup languages
		bib = {
			function()
				local current_filename = util.get_current_buffer_file_path()
				local args = { "--v2", current_filename }
				print("those args over there" .. vim.inspect(args))
				return { exe = "bibtex-tidy", args = args, stdin = true }
			end,
		},
		html = { require("formatter.filetypes.html").prettier },
		latex = { require("formatter.filetypes.latex").latexindent },
		markdown = { require("formatter.filetypes.markdown").prettier },
		toml = { require("formatter.filetypes.toml").taplo },
		yaml = { require("formatter.filetypes.yaml").yamlfmt },
		["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
	},
})
