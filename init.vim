call plug#begin()
Plug 'EdenEast/nightfox.nvim' 
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'neovim/nvim-lspconfig' 
Plug 'j-hui/fidget.nvim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'simrat39/rust-tools.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', {'tag': '0.1.0'}
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do':'make'}

call plug#end()


set completeopt=menu,menuone,noselect
set number
set t_Co=256
colorscheme carbonfox

" LUA - BASED PLUGIN CONFIGURATION 
lua << END

require'lualine'.setup {
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = { left = '', right = ''},
		section_separators = { left = '', right = ''},
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		}
		},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = {'filename'},
		lualine_x = {'encoding', 'fileformat', 'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'}
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {'location'},
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}


-- IDE-LIKE COMMANDS
-- ------------------------------

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
-- Enable completion triggered by <c-x><c-o>
vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

-- Mappings.
-- See  for documentation on any of the below functions
local bufopts = { noremap=true, silent=true, buffer=bufnr }
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
	debounce_text_changes = 150,
}

-- ------------------------------

-- A NVIM FILE EXPLORER
--------------------------------
require'nvim-tree'.setup{}


-- CONFIGURATION FOR LSP SERVERS
--------------------------------
require'mason'.setup{}
require"mason-lspconfig".setup{}
require"mason-lspconfig".setup_handlers {
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function (server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup {
			server = {
				on_attach = on_attach,
				flags = lsp_flags,
			}
		}
	end,
	-- Next, you can provide a dedicated handler for specific servers.
	-- For example, a handler override for the `rust_analyzer`:
	["rust_analyzer"] = function ()
		require("rust-tools").setup {
			server = {
				on_attach = on_attach,
				inlay_hints = {
					enable = true,
				},
				flags = lsp_flags,
			}
		}
	end
}
require'fidget'.setup{}

-- CONFIGURATION FOR SYNTAX HIGHLIGHTING 
--------------------------------
require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false, 
	}
}
require'nvim-treesitter.configs'.setup {
	parser_install_dir = "~/.local/share/nvim/plugged/nvim-treesitter",
}
vim.opt.runtimepath:append("~/.local/share/nvim/plugged/nvim-treesitter")

-- configuration for telescope 
-----------------------------
require'telescope'.setup{
	extensions = {
		fzf = {
			fuzz = true, 
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		}
	}
}
require'telescope'.load_extension'fzf'
local builtin = require'telescope.builtin'
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

END
