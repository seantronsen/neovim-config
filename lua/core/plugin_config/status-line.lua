--------------------------------
-- STATUSLINE (builtin 'statusline', replaces lualine.nvim and fidget.nvim)
--------------------------------
local M = {}

local modes = {
	n = "NORMAL",
	no = "O-PENDING",
	v = "VISUAL",
	V = "V-LINE",
	["\22"] = "V-BLOCK",
	s = "SELECT",
	S = "S-LINE",
	["\19"] = "S-BLOCK",
	i = "INSERT",
	R = "REPLACE",
	c = "COMMAND",
	r = "PROMPT",
	["!"] = "SHELL",
	t = "TERMINAL",
}

local function mode()
	local m = vim.api.nvim_get_mode().mode
	return modes[m:sub(1, 2)] or modes[m:sub(1, 1)] or m
end

-- in-flight lsp work, keyed by client and progress token. entries are dropped
-- when the server reports the work as done (vim.lsp.status() can't be used
-- here, it consumes messages on every call).
local lsp_work = {}

vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(ev)
		local key = ev.data.client_id .. ":" .. tostring(ev.data.params.token)
		local value = ev.data.params.value
		if value.kind == "end" then
			lsp_work[key] = nil
		else
			local title = value.title or (lsp_work[key] and lsp_work[key].title) or ""
			lsp_work[key] = { title = title, message = value.message, percentage = value.percentage }
		end
		vim.cmd.redrawstatus()
	end,
})

vim.api.nvim_create_autocmd("LspDetach", {
	callback = function(ev)
		for key in pairs(lsp_work) do
			if vim.startswith(key, ev.data.client_id .. ":") then
				lsp_work[key] = nil
			end
		end
	end,
})

local function lsp_progress()
	local first, count = nil, 0
	for _, work in pairs(lsp_work) do
		first = first or work
		count = count + 1
	end
	if not first then
		return ""
	end
	local text = first.title .. (first.message and (": " .. first.message) or "")
	text = #text > 40 and (text:sub(1, 39) .. "…") or text
	if first.percentage then
		text = string.format("%s %d%%", text, first.percentage)
	end
	if count > 1 then
		text = string.format("%s (+%d)", text, count - 1)
	end
	return text:gsub("%%", "%%%%") .. " "
end

-- branch and diff counts, provided by gitsigns.nvim
local function git()
	local head = vim.b.gitsigns_head
	if not head or head == "" then
		return ""
	end
	local status = vim.b.gitsigns_status
	return head .. ((status and status ~= "") and (" " .. status) or "") .. " | "
end

function M.render()
	local file = "%<%{expand('%:~:.')} %h%w%m%r"
	if tonumber(vim.g.statusline_winid) ~= vim.api.nvim_get_current_win() then
		return " " .. file .. "%=%l,%c "
	end
	return table.concat({
		" " .. mode() .. " ",
		git(),
		file,
		"%=",
		lsp_progress(),
		vim.diagnostic.status() .. " ",
		"%{&filetype} %{&fenc != '' ? &fenc : &enc} %{&ff} ",
		"%-14.(%l,%c%V%) %P ",
	})
end

vim.o.statusline = "%!v:lua.require'core.plugin_config.status-line'.render()"
vim.api.nvim_create_autocmd("ModeChanged", {
	callback = function()
		vim.cmd.redrawstatus()
	end,
})

return M
