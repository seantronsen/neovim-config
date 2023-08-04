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
				local current_filename = vim.fn.bufname()
				return { exe = "sqlfmt", args = {"" .. " " .. "-"} , stdin=true}
			end,
		},

		-- scripting languages
		sh = { require("formatter.filetypes.sh").shfmt },

		-- object documents
		json = { require("formatter.filetypes.json").prettier },

		-- markup languages
		html = { require("formatter.filetypes.html").prettier },
		latex = { require("formatter.filetypes.latex").latexindent },
		markdown = { require("formatter.filetypes.markdown").prettier },
		toml = { require("formatter.filetypes.toml").taplo },
		yaml = { require("formatter.filetypes.yaml").yamlfmt },
		["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
	},
})
