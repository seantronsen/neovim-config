-----------------------------
-- CONFIGURATION FOR DOCUMENT FORMATTING
-----------------------------

require("conform").setup({
	formatters_by_ft = {
		-- programming languages
		c = { "clang_format" },
		cpp = { "clang_format" },
		cmake = { "cmake_format" },
		go = { "gofmt" },
		javascript = { "prettier" },
		lua = { "stylua" },
		python = { "ruff_format", "ruff_organize_imports" },
		rust = { "rustfmt" },
		typescript = { "prettier" },

		-- data manipulation languages
		sql = { "sqlfmt" },

		-- scripting languages
		sh = { "shfmt" },
		bash = { "shfmt" },

		-- object documents
		json = { "prettier" },
		proto = { "buf" },

		-- markup languages
		bib = { "bibtex-tidy" },
		html = { "prettier" },
		xml = { "xmlformatter" },
		latex = { "latexindent" },
		tex = { "latexindent" },
		markdown = { "prettier" },
		toml = { "taplo" },
		yaml = { "yamlfmt" },

		["*"] = { "trim_whitespace" },
	},
	-- overrides for the builtin formatter definitions above
	formatters = {
		["bibtex-tidy"] = {
			prepend_args = { "--v2" },
		},
		latexindent = {
			args = { "-g", "/dev/null", "-m", "-l", vim.fn.stdpath("config") .. "/latexindent.yaml", "-" },
		},
		-- enforce auto line wrapping in markdown docs
		prettier = {
			prepend_args = function(_, ctx)
				if vim.bo[ctx.buf].filetype == "markdown" then
					return { "--print-width", "80", "--prose-wrap", "always" }
				end
				return {}
			end,
		},
	},
})

vim.keymap.set("n", "<leader>re", function() require("conform").format({ async = true }) end, { desc = "[r]e[f]ormat" })
vim.keymap.set("n", "<leader>nh", function() vim.cmd("nohls") end, { desc = "[n]o [h]ighlight" })
