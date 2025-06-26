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

vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(ev)
        -- local client = vim.lsp.get_client_by_id(ev.data.client_id)

			-- disable formatting from non formatter.nvim sources, so it doesn't
				-- interfere with gqq
				vim.bo[bufnr].formatexpr = nil
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


      end
})



local lsp_flags = { debounce_text_changes = 100 }

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

local is_headless = require("core.utils").is_running_in_headless_mode()
require("mason-lspconfig").setup({
	-- ensure_installed = is_headless and {} or require("core.plugin_config.mason.mason-installs"),
	ensure_installed = {}, -- is_headless and {} or require("core.plugin_config.mason.mason-installs"),
	automatic_installation = false,
})

require("mason-tool-installer").setup({
	ensure_installed = is_headless and {}
		or require("core.plugin_config.mason.mason-tool-installs"),
	auto_update = false,
})

-- require("neodev").setup()
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- possible deletion candidate
--
-- local lspsaga = require("lspsaga")
-- lspsaga.setup({
-- 
-- 	ui = {
-- 		code_action = "A",
-- 	},
-- 	lightbulb = {
-- 		sign = false,
-- 	},
-- 	implement = {
-- 		sign = false,
-- 	},
-- })

-- possible deletion candidate
-- 
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "bats",
-- 	callback = function()
-- 		vim.cmd([[set ft=bash]])
-- 	end,
-- })

-- require("mason-lspconfig").setup_handlers({
-- 	--------------------------------
-- 	-- the default handler that's called for any installed server that
-- 	-- doesn't already have a dedicated handler.
-- 	--
-- 	-- note that it makes some assumptions about the nature of
-- 	-- the server (compare the default with the setup for
-- 	-- rust_analyzer).
-- 	--------------------------------
-- 	function(server_name)
-- 		require("lspconfig")[server_name].setup({
-- 			on_attach = on_attach,
-- 			flags = lsp_flags,
-- 			capabilities = capabilities,
-- 		})
-- 	end,
-- 
-- 	["lua_ls"] = function()
-- 		require("lspconfig").lua_ls.setup({
-- 			on_attach = on_attach,
-- 			flags = lsp_flags,
-- 			capabilities = capabilities,
-- 			settings = {
-- 				Lua = {
-- 					-- diagnostics = {
-- 					-- 	globals = { "vim" },
-- 					-- },
-- 					workspace = {
-- 						checkThirdParty = false,
-- 					},
-- 				},
-- 			},
-- 		})
-- 	end,
-- 
-- 	-- todo: possibly unnecessary
-- 	["pyright"] = function()
-- 		require("lspconfig").pyright.setup({
-- 			on_attach = on_attach,
-- 			flags = lsp_flags,
-- 			capabilities = capabilities,
-- 			settings = {
-- 				python = {
-- 					analysis = {
-- 						diagnosticMode = "workspace",
-- 						useLibraryCodeForTypes = true,
-- 						typeCheckingMode = "strict",
-- 						stubPath = "typings",
-- 					},
-- 				},
-- 			},
-- 		})
-- 	end,
-- })
