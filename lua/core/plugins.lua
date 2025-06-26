local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- lazy requires map leader to be set before plugin setups
vim.g.mapleader = ","

require("lazy").setup({
	-- can we get rid of this one? seems unnecessary
	-- { "folke/neoconf.nvim", cmd = "Neoconf" },
	-- check out https://github.com/folke/lazydev.nvim instead when time permits

	--THEMES
	--------------------------------
	"EdenEast/nightfox.nvim",

	--STATUS LINE
	--------------------------------

	-- "kyazdani42/nvim-web-devicons",
	{ "nvim-lualine/lualine.nvim", commit = "2248ef2" },
	{ "j-hui/fidget.nvim", tag = "v1.6.1", event = "LspAttach" },

	--LANGUAGE SERVER AND INFORMATION HIGHLIGHTING
	--------------------------------

	{ "neovim/nvim-lspconfig", tag = "v2.3.0" }, -- possible candidate for removal
	{ "williamboman/mason.nvim", tag = "v2.0.0" },
	
	{ "WhoIsSethDaniel/mason-tool-installer.nvim", commit = "93a9ff9" },
	{ "williamboman/mason-lspconfig.nvim", tag = "v2.0.0" },
	{ "nvim-treesitter/nvim-treesitter", tag = "v0.10.0", build = ":TSUpdate" },
	"folke/neodev.nvim", -- removal candidate

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
	{ "kkoomen/vim-doge", build = ":call doge#install()" },
	{ "danymat/neogen", tag = "2.17.1" },

	--TMUX COMPATIBILITY
	--------------------------------
	-- {
	-- 	"christoomey/vim-tmux-navigator",
	-- 	cmd = {
	-- 		"TmuxNavigateLeft",
	-- 		"TmuxNavigateDown",
	-- 		"TmuxNavigateUp",
	-- 		"TmuxNavigateRight",
	-- 		"TmuxNavigatePrevious",
	-- 		"TmuxNavigatorProcessList",
	-- 	},
	-- 	keys = {
	-- 		{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
	-- 		{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
	-- 		{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
	-- 		{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
	-- 		{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
	-- 	},
	-- },
})
