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

	--GIT
	--------------------------------
	-- also feeds the branch/diff section of the statusline (see status-line.lua)
	{ "lewis6991/gitsigns.nvim", tag = "v2.1.0", event = { "BufReadPre", "BufNewFile" }, opts = {} },

	--LANGUAGE SERVERS & HIGHLIGHTING
	--------------------------------

	{
		"mason-org/mason.nvim",
		tag = "v2.3.1",
		dependencies = {
			{ "neovim/nvim-lspconfig", tag = "v2.12.0" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim", commit = "443f1ef" },
		},
	},

	-- NOTE: compiling parsers requires tree-sitter-cli (built by the Makefile)
	{ "nvim-treesitter/nvim-treesitter", branch = "main", commit = "a2f6944", build = ":TSUpdate" },

	-- NOTES
	--------------------------------
	-- since this is lazy loaded, docs are unavailable until one opens a .tex file
	{ "lervag/vimtex", tag = "v2.18", ft = { "tex", "markdown" } },
	{
		"obsidian-nvim/obsidian.nvim",
		tag = "v3.16.10",
		ft = { "markdown" },
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ "HakonHarnes/img-clip.nvim", event = "VeryLazy", ft = { "markdown" } },

	-- DEBUGGING | DEBUG-ADAPTER-PROTOCOL
	--------------------------------
	{
		"mfussenegger/nvim-dap",
		tag = "0.10.0",
		dependencies = {
			{ "mfussenegger/nvim-dap-python" },
			-- latest tag (v4.0.0) calls vim.tbl_flatten, deprecated in nvim 0.12
			{ "rcarriga/nvim-dap-ui", commit = "cc9dd33", dependencies = { { "nvim-neotest/nvim-nio" } } },
			{ "theHamsta/nvim-dap-virtual-text", commit = "fbdb48c" },
		},
	},

	--DOCUMENT FORMATTING
	--------------------------------
	{ "stevearc/conform.nvim", tag = "v9.1.0" },

	--FILE EXPLORATION AND PREVIEWS
	--------------------------------
	{ "stevearc/oil.nvim", tag = "v2.16.0" },
	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.2.2",
		dependencies = { { "nvim-lua/plenary.nvim" } },
	},

	-- SNIPPETS
	--------------------------------
	-- completion itself is builtin as of nvim 0.12 (see autocomplete.lua)
	{ "L3MON4D3/LuaSnip" },

	-- AUTODOCUMENTATION
	--------------------------------
	{ "danymat/neogen", tag = "2.20.0" },

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
