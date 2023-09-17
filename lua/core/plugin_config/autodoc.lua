-- DOGE MAPPINGS
-----------------------
vim.g.doge_enable_mappings = 0

local function generate()
	vim.cmd("DogeGenerate")
end

vim.keymap.set("n", "<leader>cf", generate, { desc = "[c]omment [f]unction autodoc", noremap = true, silent = true })

-- NEOGEN MAPPINGS
-----------------------
-- local ng = require("neogen")
--
-- ng.setup({
-- 	enabled = true,
-- 	snippet_engine = "luasnip",
-- 	languages = {
-- 		python = {
-- 			template = {
-- 				annotation_convention = "numpydoc",
-- 			},
-- 		},
-- 	},
-- })

-- local function generate_class_doc()
-- 	ng.generate({ type = "class" })
-- end
--
-- local function generate_type_doc()
-- 	ng.generate({ type = "type" })
-- end
--
-- local function generate_file_doc()
-- 	ng.generate({ type = "file" })
-- end
--
-- vim.keymap.set("n", "<leader>cf", ng.generate, { desc = "[c]omment [f]unction autodoc", noremap = true, silent = true })
-- vim.keymap.set(
-- 	"n",
-- 	"<leader>cc",
-- 	generate_class_doc,
-- 	{ desc = "[c]omment [c]lass autodoc", noremap = true, silent = true }
-- )
-- vim.keymap.set(
-- 	"n",
-- 	"<leader>ct",
-- 	generate_type_doc,
-- 	{ desc = "[c]omment [t]ype autodoc", noremap = true, silent = true }
-- )
-- vim.keymap.set(
-- 	"n",
-- 	"<leader>cb",
-- 	generate_file_doc,
-- 	{ desc = "[c]omment [b]uffer autodoc", noremap = true, silent = true }
-- )
