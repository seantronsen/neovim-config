call plug#begin()

" THEMES
" ------------------------------
Plug 'EdenEast/nightfox.nvim'

" STATUS LINE
" ------------------------------
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" LANGUAGE SERVER AND INFORMATION HIGHLIGHTING
" ------------------------------
Plug 'neovim/nvim-lspconfig'
Plug 'j-hui/fidget.nvim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'simrat39/rust-tools.nvim'
Plug 'kdarkhan/rust-tools.nvim'

" DOCUMENT FORMATTING
" ------------------------------
Plug 'mhartington/formatter.nvim'

" FILE EXPLORATION AND PREVIEWS
" ------------------------------
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', {'tag': '0.1.0'}
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do':'make'}

" AUTOCOMPLETE
" ------------------------------
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'


call plug#end()


" DEFAULT SETTINGS
set completeopt=menu,menuone,noselect
set number
set t_Co=256
colorscheme carbonfox
" AUTO COMPLETE ON-DEMAND ONLY
inoremap <C-x><C-o> <Cmd>lua require'cmp'.complete()<CR>

" CUSTOM COMMANDS 
command NVO NvimTreeOpen
command NVC NvimTreeClose

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


-- A NVIM FILE EXPLORER
--------------------------------
require'nvim-tree'.setup{}



-- CONFIGURATION FOR AUTO-COMPLETE
--------------------------------
-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup(
{
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
		require('luasnip').lsp_expand(args.body)
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
	-- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
	-- ['<C-f>'] = cmp.mapping.scroll_docs(4),
	-- ['<C-Space>'] = cmp.mapping.complete(),
	-- ['<C-e>'] = cmp.mapping.abort(),
	['<C-Space>'] = cmp.mapping.confirm({ select = true }),
	-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({{ name = 'nvim_lsp' }, { name = 'luasnip' }}, {{ name = 'buffer' }}),
	-- TODO - write a command that toggles the behavior below.
	-- comment/uncomment the lines below to disable/enable autocomplete features
	-- preselect = cmp.PreselectMode,
	-- completion = { autocomplete = false }
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({{ name = 'cmp_git' }}, {{ name = 'buffer' }})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {{ name = 'buffer' }}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':',
{
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({{ name = 'path' }}, {{ name = 'cmdline' }})
})


local capabilities = require("cmp_nvim_lsp").default_capabilities()




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
				inlay_hints = {
					enable = true,
				},
				capabilities=capabilities
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
				capabilities=capabilities
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


-- CONFIGURATION FOR DOCUMENT FORMATTING
-----------------------------
-- Utilities for creating configurations
local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		-- Formatter configurations for filetype "lua" go here
		-- and will be executed in order
		lua = { require("formatter.filetypes.lua").stylua, },
		rust = { require("formatter.filetypes.rust").rustfmt, },
		python = { require("formatter.filetypes.python").black, },
		["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
} }
END
