-----------------------------
-- CONFIGURATION FOR DOCUMENT FORMATTING
-----------------------------

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
local util = require("formatter.util")
local get_current_filename = function()
	return util.get_current_buffer_file_path()
end
local latexfmt = function()
	local args = { "-g", "/dev/null", "-m" }
	return { exe = "latexindent", args = args, stdin = true }
end

local python_ruff_isort_fmt = function()
	local args = { "-q", "check", "--select", "I", "--fix", "-" }
	return { exe = "ruff", args = args, stdin = true }
end

local sqlfmt = function()
	local args = { " ", "-" }
	return { exe = "sqlfmt", args = args, stdin = true }
end

local xmlfmt = function()
	local args = { " ", "-" }
	return { exe = "xmlformat", args = args, stdin = true }
end

local max_line_chars = 120

require("formatter").setup({
	logging = true, -- Enable or disable logging
	log_level = vim.log.levels.WARN, -- Set the log level

	-- All formatter configurations are opt-in
	filetype = {
		-- programming languages
		c = { require("formatter.filetypes.c").clangformat },
		cpp = { require("formatter.filetypes.cpp").clangformat },
		cmake = { require("formatter.filetypes.cmake").cmakeformat },
		javascript = { require("formatter.filetypes.javascript").prettier },
		lua = { require("formatter.filetypes.lua").stylua },
		python = { require("formatter.filetypes.python").ruff, python_ruff_isort_fmt },
		rust = { require("formatter.filetypes.rust").rustfmt },
		typescript = { require("formatter.filetypes.javascript").prettier },

		-- data manipulation languages
		sql = { sqlfmt },

		-- scripting languages
		sh = { require("formatter.filetypes.sh").shfmt },
		bash = { require("formatter.filetypes.sh").shfmt },

		-- object documents
		json = { require("formatter.filetypes.json").prettier },

		-- markup languages
		bib = {
			function()
				local current_filename = get_current_filename()
				local args = { "--v2", current_filename }
				print("those args over there" .. vim.inspect(args))
				return { exe = "bibtex-tidy", args = args, stdin = true }
			end,
		},
		html = { require("formatter.filetypes.html").prettier },
		xml = { xmlfmt },
		latex = { latexfmt },
		tex = { latexfmt },
		-- markdown = { require("formatter.filetypes.markdown").prettier },

		-- a "more custom" definition to enforce auto line wrapping in markdown docs.
		markdown = {

			function(parser)
				---@diagnostic disable-next-line: redefined-local
				local max_line_chars = 80
				if not parser then
					return {
						exe = "prettier",
						args = {
							"--stdin-filepath",
							vim.api.nvim_buf_get_name(0),
							"--print-width",
							tostring(max_line_chars),
							"--prose-wrap",
							"always",
						},
						stdin = true,
						try_node_modules = true,
					}
				end

				return {
					exe = "prettier",
					args = {
						"--stdin-filepath",
						vim.api.nvim_buf_get_name(0),
						"--print-width",
						tostring(max_line_chars),
						"--prose-wrap",
						"always",
						"--parser",
						parser,
					},
					stdin = true,
					try_node_modules = true,
				}
			end,
		},

		-- xml = { require("formatter.filetypes.xml").tidy },
		toml = { require("formatter.filetypes.toml").taplo },
		yaml = { require("formatter.filetypes.yaml").yamlfmt },
		["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
	},
})

vim.keymap.set("n", "<leader>re", function() vim.cmd("Format") end, { desc = "[r]e[f]ormat" })
vim.keymap.set("n", "<leader>nh", function() vim.cmd("nohls") end, { desc = "[n]o [h]ighlight" })
