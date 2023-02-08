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
Plug 'j-hui/fidget.nvim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'simrat39/rust-tools.nvim'


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

" TMUX COMPATIBILITY
" ------------------------------
Plug 'christoomey/vim-tmux-navigator'

call plug#end()


" DEFAULT SETTINGS
set completeopt=menu,menuone,noselect
set number
set t_Co=256
set mouse=c
colorscheme carbonfox

" DISABLED
let g:loaded_python3_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0

" AUTO COMPLETE ON-DEMAND ONLY
" TODO: is this actually doing anything?
inoremap <C-x><C-o> <Cmd>lua require'cmp'.complete()<CR>

" CUSTOM COMMANDS
command Nvt NvimTreeToggle

" LUA - BASED PLUGIN CONFIGURATION
lua << END


-- LUALINE/POWERLINE
-- ------------------------------
require'lualine'.setup {}


-- IDE-LIKE COMMANDS
-- ------------------------------

-- ------------------------------
-- TODO: FIX THESE UP
-- ------------------------------
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	-- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See  for documentation on any of the below functions
	local bufopts = { noremap=true, silent=true, buffer=bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
	-- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
	-- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, {})
	vim.keymap.set('n', '<space>h', vim.lsp.buf.hover, {})
	vim.keymap.set('n', '<leader>fr', require('telescope.builtin').lsp_references, {})
end

local lsp_flags = { debounce_text_changes = 150 }


-- A NVIM FILE EXPLORER
--------------------------------
require'nvim-tree'.setup{}


-- CONFIGURATION FOR AUTO-COMPLETE
--------------------------------
local cmp = require'cmp'

cmp.setup(
{
	snippet = {
		expand = function(args)
		require('luasnip').lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
	-- TODO: DETERMINE KEYMAP FOR DOCS SCROLL
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
require"mason-lspconfig".setup{
	ensure_installed = {"rust_analyzer", "sumneko_lua", "bashls", "clangd", "cmake", "dockerls", "html", "jsonls", "ltex", "marksman", "pyright", "taplo", "yamlls"},
	automatic_installation = false,
}
require"mason-lspconfig".setup_handlers {
	-- default handler that's called for any installed server that
	-- doesn't already have a dedicated handler.
	--
	-- note that it makes some assumptions about the nature of
	-- the server (compare the default with the setup for
	-- rust_analyzer).
	function (server_name)
		require("lspconfig")[server_name].setup {
			on_attach = on_attach,
			flags = lsp_flags,
			inlay_hints = {
				enable = true,
			},
			capabilities=capabilities
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
vim.opt.runtimepath:append("~/.local/share/nvim/plugged/nvim-treesitter")
require'nvim-treesitter.configs'.setup {
	ensure_installed = { "c", "cpp", "dockerfile", "lua", "vim", "python", "rust", "json", "html", "bash", "markdown", "make", "yaml", "toml" },
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	parser_install_dir = "~/.local/share/nvim/plugged/nvim-treesitter",

}

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
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})


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
		json = { require("formatter.filetypes.json").prettier, },
		["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
} }
END
