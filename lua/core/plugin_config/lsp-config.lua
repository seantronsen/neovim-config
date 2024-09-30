-- ------------------------------
-- IDE-LIKE COMMANDS
-- ------------------------------
vim.keymap.set(
	"n",
	"<leader>e",
	vim.diagnostic.open_float,
	{ desc = "display error", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"[d",
	vim.diagnostic.goto_prev,
	{ desc = "go to previous [d]iagnostic", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"]d",
	vim.diagnostic.goto_next,
	{ desc = "go to next [d]iagnostic", noremap = true, silent = true }
)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer

local on_attach = function(_, _)
	-- Mappings.
	-- See  for documentation on any of the below functions
	-- local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "[g]o to [D]eclaration" })
	vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "[g]o to [d]efinition" })
	vim.keymap.set(
		"n",
		"<leader>gt",
		vim.lsp.buf.type_definition,
		{ desc = "[g]o to symbol [t]ype definition" }
	)
	vim.keymap.set(
		"n",
		"<leader>gi",
		vim.lsp.buf.implementation,
		{ desc = "[g]o to [i]mplementation" }
	)
	vim.keymap.set(
		"n",
		"<leader>h",
		vim.lsp.buf.hover,
		{ desc = "[h]elp (information for hovered item)" }
	)
	vim.keymap.set(
		"n",
		"<leader>fr",
		require("telescope.builtin").lsp_references,
		{ desc = "[f]ind [r]eferences" }
	)

	-- CODE ACTION
	vim.keymap.set("n", "<leader>a", function()
		vim.cmd([[Lspsaga code_action]])
	end, { desc = "code [a]ction" })

	-- REFACTORING
	vim.keymap.set("n", "<leader>rr", function()
		vim.cmd([[Lspsaga rename]])
	end, { desc = "[r]efactor [r]ename symbol and references" })

	vim.keymap.set("n", "<leader>rp", function()
		local name_old = vim.fn.input("old name: ")
		local name_new = vim.fn.input("new name: ")

		if vim.fn.empty(name_old) == 1 or vim.fn.empty(name_new) then
			print("error: name cannot be empty")
		else
			vim.cmd([[Lspsaga project_replace ]] .. name_old .. " " .. name_new)
		end
	end, { desc = "[r]efactor rename project matches" })
end

local lsp_flags = { debounce_text_changes = 100 }

--------------------------------
-- CONFIGURATION FOR LSP SERVERS
--------------------------------
require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})
require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls",
		"clangd",
		"cmake",
		"dockerls",
		"html",
		"jsonls",
		"lua_ls",
		"marksman",
		-- "basedpyright",
		"pyright",
		"rust_analyzer",
		"taplo",
		"yamlls",
	},
	automatic_installation = false,
})

require("mason-tool-installer").setup({
	ensure_installed = {
		"black",
		"bibtex-tidy",
		"debugpy",
		"bash-debug-adapter",
		"prettier",
		"shfmt",
		"sqlfmt",
		"stylua",
		"yamlfmt",
	},
	auto_update = true,
})

require("neodev").setup()
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspsaga = require("lspsaga")
lspsaga.setup({
	lightbulb = {
		sign = false,
	},
	implement = {
		sign = false,
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "bats",
	callback = function()
		vim.cmd([[set ft=bash]])
	end,
})

require("mason-lspconfig").setup_handlers({
	--------------------------------
	-- the default handler that's called for any installed server that
	-- doesn't already have a dedicated handler.
	--
	-- note that it makes some assumptions about the nature of
	-- the server (compare the default with the setup for
	-- rust_analyzer).
	--------------------------------
	function(server_name)
		require("lspconfig")[server_name].setup({
			on_attach = on_attach,
			flags = lsp_flags,
			capabilities = capabilities,
		})
	end,

	--------------------------------
	-- Next, you can provide a dedicated handler for specific servers.
	-- For example, a handler override for the `rust_analyzer`:
	--------------------------------
	["rust_analyzer"] = function()
		local extension_path = vim.env.HOME .. "/sources/codelldb-1.8.1/codelldb-x86_64-linux"
		local codelldb_path = extension_path .. "/adapter/codelldb"
		local liblldb_path = extension_path .. "/lldb/lib/liblldb.so"
		local rust_tools = require("rust-tools")

		local rust_on_attach = function(_, _)
			on_attach()

			-- rust unique
			vim.keymap.set(
				"n",
				"<leader>h",
				rust_tools.hover_actions.hover_actions,
				{ desc = "[h]elp (information for hovered item)" }
			)

			-- vim.keymap.set( "n", "<leader>ag", rust_tools.code_action_group.code_action_group, { desc = "code [a]ction group" })
		end

		-- Normal setup
		rust_tools.setup({
			flags = lsp_flags,
			capabilities = capabilities,
			tools = {
				inlay_hints = {
					enable = true,
				},
				hover_actions = {
					auto_focus = true,
				},
			},
			server = {
				on_attach = rust_on_attach,
			},
			dap = {
				adapter = require("rust-tools.dap").get_codelldb_adapter(
					codelldb_path,
					liblldb_path
				),
			},
		})
	end,

	["lua_ls"] = function()
		require("lspconfig").lua_ls.setup({
			on_attach = on_attach,
			flags = lsp_flags,
			capabilities = capabilities,
			settings = {
				Lua = {
					-- diagnostics = {
					-- 	globals = { "vim" },
					-- },
					workspace = {
						checkThirdParty = false,
					},
				},
			},
		})
	end,

	-- todo: possibly unnecessary
	-- ["basedpyright"] = function()
	-- require("lspconfig").basedpyright.setup({
	["pyright"] = function()
		require("lspconfig").pyright.setup({
			on_attach = on_attach,
			flags = lsp_flags,
			capabilities = capabilities,
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
		})
	end,
})
