-- ------------------------------
-- IDE-LIKE COMMANDS
-- ------------------------------

local function diag_next()
	vim.diagnostic.jump({ count = 1, float = true })
end

local function diag_prev()
	vim.diagnostic.jump({ count = -1, float = true })
end

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "display error", noremap = true, silent = true })
vim.keymap.set("n", "]d", diag_next, { desc = "go to next [d]iagnostic", noremap = true, silent = true })
vim.keymap.set("n", "[d", diag_prev, { desc = "go to previous [d]iagnostic", noremap = true, silent = true })

-- Use an on_attach function to only map the following keys after the language
-- server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		-- disable formatting from non formatter.nvim sources, so it doesn't
		-- interfere with gqq
		vim.bo[args.buf].formatexpr = nil

		local client = vim.lsp.get_client_by_id(args.data.client_id)

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

require("mason-lspconfig").setup({
	ensure_installed = require("core.plugin_config.mason.mason-installs"),
})

require("mason-tool-installer").setup({
	ensure_installed = require("core.plugin_config.mason.mason-tool-installs"),
	auto_update = false, -- does this even work anymore....?
})

vim.lsp.config("*", {
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.lsp.config("pyright", {
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

-- pulled from: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
vim.lsp.config("lua_ls", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using (most
				-- likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		})
	end,
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
})
