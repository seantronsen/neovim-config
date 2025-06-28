local neogen = require("neogen")

neogen.setup({
	enabled = true,
	languages = {
		rust = {
			template = {
				annotation_convention = "rustdoc",
			},
		},
		python = {
			template = {
				annotation_convention = "reST",
			},
		},
	},
	-- todo: need to fix this at some point.
	-- snippet_engine = "luasnip", -- this breaks tree-sitter highlighting
})

local function generate_func_doc()
	return neogen.generate({})
end

local function generate_class_doc()
	return neogen.generate({ type = "class" })
end

local function generate_type_doc()
	return neogen.generate({ type = "type" })
end

local function generate_file_doc()
	return neogen.generate({ type = "file" })
end

vim.keymap.set(
	"n",
	"<leader>cf",
	generate_func_doc,
	{ desc = "[c]omment [f]unction autodoc", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>cc",
	generate_class_doc,
	{ desc = "[c]omment [c]lass autodoc", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>ct",
	generate_type_doc,
	{ desc = "[c]omment [t]ype autodoc", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>cb",
	generate_file_doc,
	{ desc = "[c]omment [b]uffer autodoc", noremap = true, silent = true }
)
