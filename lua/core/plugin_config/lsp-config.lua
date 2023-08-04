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
	-- Mappings.
	-- See  for documentation on any of the below functions
	-- local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "[g]o to [D]eclaration" })
	vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "[g]o to [d]efinition" })
	vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, { desc = "[g]o to symbol [t]ype definition" })
	vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "[g]o to [i]mplementation" })
	vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, { desc = "[h]elp (information for hovered item)" })
	vim.keymap.set("n", "<leader>fr", require("telescope.builtin").lsp_references, { desc = "[f]ind [r]eferences" })

	-- CODE ACTION
	vim.keymap.set("n", "<leader>ca", function()
		vim.api.nvim_command("CodeActionMenu")
	end, { desc = "[c]ode [a]ction" })

	-- REFACTORING
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
		-- "ltex",
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
		local extension_path = vim.env.HOME .. "/sources/codelldb-x86_64-linux"
		local codelldb_path = extension_path .. "/adapter/codelldb"
		local liblldb_path = extension_path .. "/lldb/lib/liblldb.so"

		-- Normal setup
		require("rust-tools").setup({
			flags = lsp_flags,
			capabilities = capabilities,
			tools = {
				inlay_hints = {
					enable = true,
				},
			},
			server = {
				on_attach = on_attach,
			},
			dap = {
				adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
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
