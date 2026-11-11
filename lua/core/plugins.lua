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

	{ "nvim-lualine/lualine.nvim", commit = "221ce6b" },
	{ "j-hui/fidget.nvim", tag = "v2.0.0", event = "LspAttach" },

	--LANGUAGE SERVERS & HIGHLIGHTING
	--------------------------------

	{
		"mason-org/mason-lspconfig.nvim",
		tag = "v2.3.0",
		dependencies = {
			{ "neovim/nvim-lspconfig", tag = "v2.12.0" },
			{ "mason-org/mason.nvim", tag = "v2.3.1" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim", commit = "443f1ef" },
		},
	},

	-- NOTE: the `master` branch is frozen (archived upstream) and officially
	-- unsupported on nvim 0.12, but still works with this config. the `main`
	-- branch rewrite requires tree-sitter-cli >= 0.26.1, whose release binaries
	-- need glibc >= 2.39. stay on the final master commit until that's sorted.
	{ "nvim-treesitter/nvim-treesitter", branch = "master", commit = "cf12346", build = ":TSUpdate" },
	{ "mfussenegger/nvim-lint", commit = "52107ce" },

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
			{ "rcarriga/cmp-dap", commit = "ea92773" },
			{ "theHamsta/nvim-dap-virtual-text", commit = "fbdb48c" },
		},
	},

	--DOCUMENT FORMATTING
	--------------------------------
	{ "mhartington/formatter.nvim", commit = "b9d7f85" },

	--FILE EXPLORATION AND PREVIEWS
	--------------------------------
	{ "stevearc/oil.nvim", tag = "v2.16.0" },
	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.2.2",
		dependencies = { { "nvim-lua/plenary.nvim" } },
	},

	-- AUTOCOMPLETE
	--------------------------------
	{
		"hrsh7th/nvim-cmp",
		-- latest tag (v0.0.2) predates nvim 0.11 and calls apis deprecated in 0.12
		commit = "fe29aba",
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
		end,
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-cmdline" },
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
		},
	},

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
