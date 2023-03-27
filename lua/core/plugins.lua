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
	use("folke/tokyonight.nvim")

	--STATUS LINE
	--------------------------------

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})
	use("kyazdani42/nvim-web-devicons")
	use("j-hui/fidget.nvim")

	--LANGUAGE SERVER AND INFORMATION HIGHLIGHTING
	--------------------------------
	use({
		"neovim/nvim-lspconfig",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	})
	use({
		"nvim-treesitter/nvim-treesitter",
		tag = "v0.7.2",
		run = ":TSUpdate",
	})
	use("simrat39/rust-tools.nvim")
	use("folke/neodev.nvim")

	-- DEBUGGING | DEBUG-ADAPTER-PROTOCOL
	--------------------------------
	use({
		"mfussenegger/nvim-dap",
		tag = "0.5.0",
		lock = true,
		requires = {
			{ "mfussenegger/nvim-dap-python" },
			{ "rcarriga/nvim-dap-ui"},
		},
	})
	-- CONDA_PREFIX

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
		requires = {
			{ "nvim-lua/plenary.nvim" },
			-- { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
		},
	})

	--AUTOCOMPLETE
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
		},
	})

	--TMUX COMPATIBILITY
	--------------------------------
	use("christoomey/vim-tmux-navigator")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
