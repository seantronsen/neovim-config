local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	--THEMES
	--------------------------------
	use("EdenEast/nightfox.nvim")
	-- use("folke/tokyonight.nvim")
	-- use("water-sucks/darkrose.nvim")

	--STATUS LINE
	--------------------------------

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})
	use("kyazdani42/nvim-web-devicons")
	use({ "j-hui/fidget.nvim", lock = true, tag = "legacy" })

	--LANGUAGE SERVER AND INFORMATION HIGHLIGHTING
	--------------------------------
	use({
		"neovim/nvim-lspconfig",
		"williamboman/mason.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"williamboman/mason-lspconfig.nvim",
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		tag = "v0.7.2",
		run = ":TSUpdate",
	})
	use("simrat39/rust-tools.nvim")
	use("folke/neodev.nvim")

	use({ "weilbith/nvim-code-action-menu", cmd = "CodeActionMenu", commit = "e4399db", lock = true })

	use({
		"epwalsh/obsidian.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		lock = true,
		tag = "v1.12.0",
	})

	use({ "lervag/vimtex", tag = "v2.13", lock = true, ft = { "plaintex", "latex", "tex", "markdown", "mkd" } })

	-- DEBUGGING | DEBUG-ADAPTER-PROTOCOL
	--------------------------------
	use({
		"mfussenegger/nvim-dap",
		tag = "0.5.0",
		lock = true,
		requires = {
			{ "mfussenegger/nvim-dap-python" },
			{ "rcarriga/nvim-dap-ui", tag = "v3.8.0", lock = true },
			{ "rcarriga/cmp-dap", commit = "d16f14a", lock = true },
			{ "theHamsta/nvim-dap-virtual-text", commit = "ab988db", lock = true },
		},
	})

	-- VIM SLIME
	--------------------------------
	use({
		"klafyvel/vim-slime-cells",
		commit = "2252bc8",
		lock = true,
		requires = {
			{ "jpalardy/vim-slime", commit = "bb15285", lock = true },
		},
	})

	--DOCUMENT FORMATTING
	--------------------------------
	use("mhartington/formatter.nvim")

	--FILE EXPLORATION AND PREVIEWS
	--------------------------------
	use({
		"nvim-tree/nvim-tree.lua",
		requires = { "nvim-tree/nvim-web-devicons" },
	})
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
		lock = true,
		requires = {
			{ "nvim-lua/plenary.nvim" },
			-- { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
		},
	})

	-- AUTOCOMPLETE
	--------------------------------
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "L3MON4D3/LuaSnip" },
			-- { "rafamadriz/friendly-snippets" },
			{ "saadparwaiz1/cmp_luasnip" },
		},
	})

	-- AUTODOCUMENTATION
	--------------------------------

	-- better rust documentation generation
	use({ "kkoomen/vim-doge", run = ":call doge#install()" })

	-- too many issues as of 09172023. might try again in the future
	-- use({ "danymat/neogen", tag = "2.14.1" })

	-- GIT
	--------------------------------
	use({ "sindrets/diffview.nvim", commit = "a111d19" })

	--TMUX COMPATIBILITY
	--------------------------------
	use("christoomey/vim-tmux-navigator")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
