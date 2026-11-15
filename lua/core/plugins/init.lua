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

-- plugin configs. each module has `init` (runs at startup, before the plugin
-- loads: keymaps and commands, which load lazy plugins on first use) and/or
-- `config` (runs when the plugin loads, right away for `lazy = false`).
local colorscheme = require("core.plugins.colorscheme")
local file_explorer = require("core.plugins.file-explorer")
local syntax = require("core.plugins.syntax-highlight")
local git = require("core.plugins.git")
local latex = require("core.plugins.vimtex")
local dap = require("core.plugins.dap")
local formatter = require("core.plugins.formatter")
local lsp = require("core.plugins.lsp")
local notes = require("core.plugins.obsidian")
local search = require("core.plugins.search")
local status_line = require("core.plugins.status-line")
local autodoc = require("core.plugins.autodoc")
local clipboard = require("core.plugins.clipboard")

require("lazy").setup({

	--COLORSCHEME
	--------------------------------
	{ "EdenEast/nightfox.nvim", lazy = false, priority = 1000, config = colorscheme.config },

	--STATUS
	--------------------------------
	{ "nvim-lualine/lualine.nvim", commit = "221ce6b", lazy = true, event = "VeryLazy", config = status_line.config },

	--GIT
	--------------------------------
	-- also feeds the branch/diff section of the statusline (see status-line.lua)
	-- latest tag (v2.1.0) predates the unified (inline) diff view and several
	-- blame/diffthis fixes
	{
		"lewis6991/gitsigns.nvim",
		commit = "74bbddd",
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
		init = git.init,
		config = git.config,
	},

	--LANGUAGE SERVERS & HIGHLIGHTING
	--------------------------------

	{
		"mason-org/mason.nvim",
		tag = "v2.3.1",
		lazy = true,
		event = "VeryLazy",
		config = lsp.config,
		dependencies = {
			-- data only: the per-server `lsp/<name>.lua` defaults that vim.lsp.enable()
			-- reads (see lsp.lua). its old setup() API is what's deprecated
			{ "neovim/nvim-lspconfig", tag = "v2.12.0" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim", commit = "443f1ef" },
		},
	},

	-- NOTE: compiling parsers requires tree-sitter-cli (built by the Makefile)
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		commit = "a2f6944",
		lazy = false,
		build = ":TSUpdate",
		config = syntax.config,
	},

	-- NOTES
	--------------------------------
	-- lazy load, docs are unavailable until opening a .tex file
	{ "lervag/vimtex", tag = "v2.18", lazy = true, ft = { "tex" }, init = latex.init },
	{
		"obsidian-nvim/obsidian.nvim",
		tag = "v3.16.10",
		lazy = true,
		ft = { "markdown" },
		cmd = "Obsidian",
		init = notes.init,
		config = notes.config,
		-- its picker config only finds telescope once telescope is loaded
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
	{ "HakonHarnes/img-clip.nvim", lazy = true, init = clipboard.init, config = clipboard.config },

	-- DEBUGGING | DEBUG-ADAPTER-PROTOCOL
	--------------------------------
	{
		"mfussenegger/nvim-dap",
		tag = "0.10.0",
		lazy = true,
		init = dap.init,
		config = dap.config,
		dependencies = {
			{ "mfussenegger/nvim-dap-python" },
			-- latest tag (v4.0.0) calls vim.tbl_flatten, deprecated in nvim 0.12
			{ "rcarriga/nvim-dap-ui", commit = "cc9dd33", dependencies = { { "nvim-neotest/nvim-nio" } } },
			{ "theHamsta/nvim-dap-virtual-text", commit = "fbdb48c" },
		},
	},

	--DOCUMENT FORMATTING
	--------------------------------
	{
		"stevearc/conform.nvim",
		tag = "v9.1.0",
		lazy = true,
		cmd = "ConformInfo",
		init = formatter.init,
		config = formatter.config,
	},

	--FILE EXPLORATION AND PREVIEWS
	--------------------------------
	{ "stevearc/oil.nvim", tag = "v2.16.0", lazy = false, config = file_explorer.config },
	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.2.2",
		lazy = true,
		cmd = "Telescope",
		init = search.init,
		config = search.config,
		dependencies = { { "nvim-lua/plenary.nvim" } },
	},

	-- AUTODOCUMENTATION
	--------------------------------
	{ "danymat/neogen", tag = "2.20.0", lazy = true, cmd = "Neogen", init = autodoc.init, config = autodoc.config },

	-- CONFIGURATION TOOLS
	--------------------------------
	{
		"folke/lazydev.nvim",
		lazy = true,
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}, { rocks = { enabled = false } })

-- builtin completion (no plugin, so no spec above). nvim 0.12+
require("core.plugins.autocomplete")
