local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- lazy requires map leader to be set before plugin setups
vim.g.mapleader = ","

require("lazy").setup({
	{ "folke/neoconf.nvim", cmd = "Neoconf" },

	--THEMES
	--------------------------------
	"EdenEast/nightfox.nvim",

	--STATUS LINE
	--------------------------------

	"kyazdani42/nvim-web-devicons",
	{ "nvim-lualine/lualine.nvim", commit = "2248ef2" },
	{ "j-hui/fidget.nvim", tag = "v1.4.5", event = "LspAttach" },

	--LANGUAGE SERVER AND INFORMATION HIGHLIGHTING
	--------------------------------

	{ "neovim/nvim-lspconfig", commit = "cb49a4c" },
	{ "williamboman/mason.nvim", tag = "v1.10.0" },
	{ "WhoIsSethDaniel/mason-tool-installer.nvim", commit = "e4f3474" },
	{ "williamboman/mason-lspconfig.nvim", tag = "v1.20.0" },
	{ "nvim-treesitter/nvim-treesitter", tag = "v0.9.1", build = ":TSUpdate" },
	"simrat39/rust-tools.nvim",
	"folke/neodev.nvim",

	{ "nvimdev/lspsaga.nvim", commit = "199eb00" },

	-- note taking
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
			{ "rcarriga/cmp-dap", commit = "d16f14a" },
			{ "theHamsta/nvim-dap-virtual-text", commit = "57f1dbd" },
		},
	},

	-- VIM SLIME
	--------------------------------
	-- {
	-- 	"klafyvel/vim-slime-cells",
	-- 	commit = "2252bc8",
	-- 	dependencies = {
	-- 		{ "jpalardy/vim-slime", commit = "bb15285" },
	-- 	},
	-- },

	--DOCUMENT FORMATTING
	--------------------------------
	{ "mhartington/formatter.nvim", commit = "34dcdfa" },

	--FILE EXPLORATION AND PREVIEWS
	--------------------------------
	-- "nvim-tree/nvim-tree.lua",
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

	-- better rust documentation generation
	-- { "kkoomen/vim-doge", build = ":call doge#install()" },

	-- better docs overall, but too many issues as of 10272023. might try again in the future
	{ "danymat/neogen", tag = "2.17.1" },

	--TMUX COMPATIBILITY
	--------------------------------
	"christoomey/vim-tmux-navigator",
})
