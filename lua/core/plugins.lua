local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- lazy requires map leader to be set before plugin setups
vim.g.mapleader = ","

require("lazy").setup({

	--COLORSCHEME
	--------------------------------
	{ "EdenEast/nightfox.nvim" },

	--STATUS
	--------------------------------

	{ "nvim-lualine/lualine.nvim", commit = "2248ef2" },
	{ "j-hui/fidget.nvim", tag = "v1.6.1", event = "LspAttach" },

	--LANGUAGE SERVERS & HIGHLIGHTING
	--------------------------------

	-- { "neovim/nvim-lspconfig", tag = "v2.3.0" }, -- todo: now built-in to the editor itself
	{ "williamboman/mason.nvim", tag = "v2.0.0" },
	{ "williamboman/mason-lspconfig.nvim", tag = "v2.0.0" },

	{ "WhoIsSethDaniel/mason-tool-installer.nvim", commit = "93a9ff9" },
	{ "nvim-treesitter/nvim-treesitter", tag = "v0.10.0", build = ":TSUpdate" },

	-- NOTES
	--------------------------------
	{ "lervag/vimtex", tag = "v2.13", ft = { "tex", "markdown" } },
	{ "epwalsh/obsidian.nvim", dependencies = { "nvim-lua/plenary.nvim" }, tag = "v3.9.0" },
	{ "HakonHarnes/img-clip.nvim", event = "VeryLazy" },

	-- DEBUGGING | DEBUG-ADAPTER-PROTOCOL
	--------------------------------
	{
		"mfussenegger/nvim-dap",
		tag = "0.6.0",
		dependencies = {
			{ "mfussenegger/nvim-dap-python" },
			{ "rcarriga/nvim-dap-ui", tag = "v3.9.1" },
			{ "theHamsta/nvim-dap-virtual-text", commit = "57f1dbd" },
			{ "rcarriga/cmp-dap", commit = "d16f14a" },
		},
	},

	--DOCUMENT FORMATTING
	--------------------------------
	{ "mhartington/formatter.nvim", commit = "34dcdfa" },

	--FILE EXPLORATION AND PREVIEWS
	--------------------------------
	{ "stevearc/oil.nvim", tag = "v2.2.0" },
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		dependencies = { { "nvim-lua/plenary.nvim" } },
	},

	-- AUTOCOMPLETE
	--------------------------------
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
		end,
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
		},
	},

	-- AUTODOCUMENTATION
	--------------------------------
	{ "danymat/neogen", tag = "2.17.1" },

	-- CONFIGURATION TOOLS
	--------------------------------
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}, { rocks = { enabled = false } })
