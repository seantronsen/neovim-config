local ls = require("luasnip")
local sn = ls.snippet_node
local i = ls.insert_node

local M = {}

M.get_visual = function(_, parent)
	if #parent.snippet.env.LS_SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
	else -- If LS_SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end

M.in_mathzone = function()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

M.not_mathzone = function()
	return not M.in_mathzone()
end

M.nalphnum = "([%W])"
M.nspacechar = "([%S]+)"
M.postspace = " "

M.charstackrep = function(base_str, capture_index)
	local func = function(_, snip)
		return string.rep(base_str, string.len(snip.captures[capture_index]))
	end

	return func
end

return M
