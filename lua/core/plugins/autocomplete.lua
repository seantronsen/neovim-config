-- CONFIGURATION FOR AUTO-COMPLETE
--------------------------------
-- builtin completion (nvim 0.12). language servers feed the popup through
-- 'omnifunc' (set by nvim when a server attaches) and vim.lsp.completion
-- (trigger characters, docs popup, snippet/import side effects on accept).
-- see `:h ins-autocompletion` and `:h lsp-completion`.
vim.o.autocomplete = true
vim.o.complete = "o"
vim.opt.completeopt:append({ "popup", "fuzzy" })
vim.o.pumborder = "rounded"

-- one toggle for both auto popups (completion while typing, signature help)
local popups_enabled = true

local function enable_lsp_completion(bufnr)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/completion" })) do
		vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = popups_enabled })
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args) enable_lsp_completion(args.buf) end,
})

-- show signature help when typing the opening paren or a comma of a call
vim.api.nvim_create_autocmd("InsertCharPre", {
	callback = function()
		if not popups_enabled or (vim.v.char ~= "(" and vim.v.char ~= ",") then return end
		vim.schedule(function()
			if #vim.lsp.get_clients({ bufnr = 0, method = "textDocument/signatureHelp" }) > 0 then
				vim.lsp.buf.signature_help({ focusable = false, close_events = { "CursorMoved", "InsertLeave" } })
			end
		end)
	end,
})

vim.keymap.set("n", "<leader>tc", function()
	popups_enabled = not popups_enabled
	vim.go.autocomplete = popups_enabled
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		enable_lsp_completion(bufnr)
	end
	vim.notify("completion popups " .. (popups_enabled and "enabled" or "disabled"))
end, { desc = "[t]oggle [c]ompletion popups" })

-- no popups in pickers. the dap repl keeps them (completion via its omnifunc).
vim.api.nvim_create_autocmd("FileType", {
	pattern = "TelescopePrompt",
	callback = function(args) vim.bo[args.buf].autocomplete = false end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "dapui_watches",
	callback = function(args) vim.bo[args.buf].omnifunc = "v:lua.require'dap.repl'.omnifunc" end,
})

-- KEYMAPS
--------------------------------
local function pum_or(key, fallback)
	return function() return vim.fn.pumvisible() == 1 and key or fallback end
end

-- NOTE: <C-j>/<C-k> fall back to pane focus (see keymaps.lua) when no popup is open
vim.keymap.set("i", "<C-j>", pum_or("<C-n>", "<Cmd>wincmd j<CR>"), { expr = true, desc = "next completion item" })
vim.keymap.set("i", "<C-k>", pum_or("<C-p>", "<Cmd>wincmd k<CR>"), { expr = true, desc = "previous completion item" })
vim.keymap.set("i", "<C-a>", pum_or("<C-e>", "<C-a>"), { expr = true, desc = "abort completion" })
vim.keymap.set("i", "<C-c>", function()
	-- re-requesting while the menu is open would briefly close it
	if vim.fn.pumvisible() == 1 then return "" end
	return vim.bo.omnifunc ~= "" and "<C-x><C-o>" or "<C-n>"
end, { expr = true, desc = "open completion menu" })
vim.keymap.set("i", "<C-Space>", function()
	if vim.fn.pumvisible() == 0 then return "" end
	-- accept the selected item, or the first one when nothing is selected
	return vim.fn.complete_info({ "selected" }).selected == -1 and "<C-n><C-y>" or "<C-y>"
end, { expr = true, desc = "confirm completion" })

-- COMMAND-LINE COMPLETION
--------------------------------
-- popup for `:` commands/paths and `/` `?` searches. see `:h cmdline-autocompletion`
vim.o.wildmode = "noselect:lastused,full"
vim.api.nvim_create_autocmd("CmdlineChanged", {
	pattern = { ":", "/", "?" },
	callback = function() vim.fn.wildtrigger() end,
})
-- keep <Up>/<Down> for history navigation while the popup is open
vim.keymap.set("c", "<Up>", function() return vim.fn.wildmenumode() == 1 and "<C-e><Up>" or "<Up>" end, { expr = true })
vim.keymap.set(
	"c",
	"<Down>",
	function() return vim.fn.wildmenumode() == 1 and "<C-e><Down>" or "<Down>" end,
	{ expr = true }
)
