-- ------------------------------
-- IDE-LIKE COMMANDS
-- ------------------------------

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "display error", noremap = true, silent = true })

-- Use an on_attach function to only map the following keys after the language
-- server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		-- disable formatting from lsp sources, so it doesn't interfere with gqq
		-- (formatting is handled by conform.nvim, see formatter.lua)
		vim.bo[args.buf].formatexpr = nil

		-- local client = vim.lsp.get_client_by_id(args.data.client_id)

		vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "[g]o to [D]eclaration" })
		vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "[g]o to [d]efinition" })
		vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, { desc = "[g]o to symbol [t]ype definition" })
		vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "[g]o to [i]mplementation" })
		vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, { desc = "[h]elp (information for hovered item)" })
		vim.keymap.set("n", "<leader>fr", require("telescope.builtin").lsp_references, { desc = "[f]ind [r]eferences" })

		-- REFACTORING
		vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename, { desc = "[r]efactor [r]ename symbol and references" })
		vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { desc = "code [a]ction" })
	end,
})

--------------------------------
-- CONFIGURATION FOR LSP SERVERS
--------------------------------
require("mason").setup({
	ui = {
		icons = {
			package_installed = "I",
			package_pending = "->",
			package_uninstalled = "X",
		},
	},
})

-- per-server overrides, passed to vim.lsp.config() (see `servers` below)
local config_gopls = {
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			gofumpt = true,
		},
	},
}

local config_pyright = {
	settings = {
		python = {
			analysis = {
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = true,
				typeCheckingMode = "strict",
				stubPath = "typings",
			},
		},
	},
}

local config_lua_ls = {
	settings = {
		Lua = {
			diagnostics = {
				globals = {
					"vim",
					"require",
				},
			},
		},
	},
}

-- language servers to install and enable. one entry per server:
--   mason  = mason package name (what `:Mason` shows, what gets installed)
--   lsp    = nvim-lspconfig config name (its `lsp/<name>.lua`, not ours). also the
--            name used by vim.lsp.config(), vim.lsp.enable(), and `:lsp`
--   bin    = executable the server runs as. reference only, it often matches
--            neither of the names above
--   config = optional overrides passed to vim.lsp.config()
-- NOTE: unknown names and missing binaries are skipped silently. check
-- `:checkhealth vim.lsp` when a server doesn't start.
local servers = {
	{ mason = "ansible-language-server", lsp = "ansiblels", bin = "ansible-language-server" },
	{ mason = "bash-language-server", lsp = "bashls", bin = "bash-language-server" },
	{ mason = "buf", lsp = "buf_ls", bin = "buf" }, -- protobuf
	{ mason = "clangd", lsp = "clangd", bin = "clangd" },
	{ mason = "cmake-language-server", lsp = "cmake", bin = "cmake-language-server" },
	{ mason = "dockerfile-language-server", lsp = "dockerls", bin = "docker-langserver" },
	{ mason = "gopls", lsp = "gopls", bin = "gopls", config = config_gopls },
	{ mason = "html-lsp", lsp = "html", bin = "vscode-html-language-server" },
	{ mason = "json-lsp", lsp = "jsonls", bin = "vscode-json-language-server" },
	{ mason = "lua-language-server", lsp = "lua_ls", bin = "lua-language-server", config = config_lua_ls },
	{ mason = "marksman", lsp = "marksman", bin = "marksman" },
	{ mason = "pyright", lsp = "pyright", bin = "pyright-langserver", config = config_pyright },
	{ mason = "ruff", lsp = "ruff", bin = "ruff" },
	{ mason = "rust-analyzer", lsp = "rust_analyzer", bin = "rust-analyzer" },
	{ mason = "systemd-lsp", lsp = "systemd_lsp", bin = "systemd-lsp" }, -- needs glibc >= 2.34
	{ mason = "taplo", lsp = "taplo", bin = "taplo" },
	{ mason = "yaml-language-server", lsp = "yamlls", bin = "yaml-language-server" },
}

-- everything else installed through mason (formatters, linters, debuggers)
local tools = {
	"ansible-lint", -- run by ansiblels, not conform
	"bash-debug-adapter",
	"bibtex-tidy",
	"clang-format",
	"cmakelang",
	"codelldb",
	"debugpy",
	"latexindent",
	"prettier",
	"shellcheck",
	"shfmt",
	"sqlfmt",
	"stylua",
	"xmlformatter",
	"yamlfmt",
}

local ensure_installed = vim.list_slice(tools)
for _, server in ipairs(servers) do
	table.insert(ensure_installed, server.mason)
	if server.config then
		vim.lsp.config(server.lsp, server.config)
	end
	vim.lsp.enable(server.lsp)
end

require("mason-tool-installer").setup({
	ensure_installed = ensure_installed,
	auto_update = false,
})
