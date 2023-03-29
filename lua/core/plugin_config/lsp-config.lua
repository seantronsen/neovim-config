-- ------------------------------
-- IDE-LIKE COMMANDS
-- ------------------------------
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, _)
	-- Enable completion triggered by <c-x><c-o>
	-- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See  for documentation on any of the below functions
	-- local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gdD", vim.lsp.buf.declaration, { desc = "[g]o to [d]efinition: [D]eclaration" })
	vim.keymap.set("n", "gdd", vim.lsp.buf.definition, { desc = "[g]o to [d]efinition: [d]efinition" })
	vim.keymap.set("n", "gdt", vim.lsp.buf.type_definition, { desc = "[g]o to [d]efinition: symbol [t]ype definition" })
	-- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
	vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, { desc = "[h]elp (information for hovered item)" })
	vim.keymap.set("n", "<leader>fr", require("telescope.builtin").lsp_references, { desc = "[f]ind [r]eferences" })

	-- refactoring
	vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename, { desc = "[r]efactor [r]ename symbol and references" })
end

local lsp_flags = { debounce_text_changes = 150 }

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
		"ltex",
		"lua_ls",
		"marksman",
		"pyright",
		"rust_analyzer",
		"taplo",
		"yamlls",
	},
	automatic_installation = false,
})

require("neodev").setup()
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("mason-lspconfig").setup_handlers({
	--------------------------------
	-- default handler that's called for any installed server that
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
			inlay_hints = {
				enable = true,
			},
			capabilities = capabilities,
		})
	end,
	--------------------------------
	-- Next, you can provide a dedicated handler for specific servers.
	-- For example, a handler override for the `rust_analyzer`:
	--------------------------------
	["rust_analyzer"] = function()
		local extension_path = vim.env.HOME .. "/sources/codelldb-x86_64-linux"
		local codelldb_path = extension_path .. "/adapter/codelldb"
		local liblldb_path = extension_path .. "/lldb/lib/liblldb.so"

		-- Normal setup
		require("rust-tools").setup({
			server = {
				on_attach = on_attach,
				inlay_hints = {
					enable = true,
				},
				flags = lsp_flags,
				capabilities = capabilities,
			},
			dap = {
				adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
			},
		})
	end,

	["clangd"] = function()
		-- Normal setup
		require("lspconfig").clangd.setup({
			server = {
				on_attach = on_attach,
				inlay_hints = {
					enable = true,
				},
				flags = lsp_flags,
				capabilities = capabilities,
			},
		})
	end,

	["lua_ls"] = function()
		require("lspconfig").lua_ls.setup({

			server = {
				on_attach = on_attach,
				inlay_hints = {
					enable = true,
				},
				flags = lsp_flags,
				capabilities = capabilities,
			},
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						checkThirdParty = false,
					},
				},
			},
		})
	end,
})
