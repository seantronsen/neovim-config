local ls = require("luasnip")
local nfunc = ls.function_node
local ndynamic = ls.dynamic_node
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

M.nvisual = function(index_jump)
	return ndynamic(index_jump, M.get_visual)
end

M.in_mathzone = function()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

M.not_mathzone = function()
	return not M.in_mathzone()
end

M.captschars = "([$%s]+)"
-- need to update so that way patterns aren't considering the initial mathzone character for consumption.
-- M.captschars = "([$]?)([%s]+)"
M.capttchars = "([%S]+)"
M.postspace = " "

M.ncapture = function(index_capture)
	return nfunc(function(_, snip)
		return snip.captures[index_capture]
	end)
end

M.ncapturestack = function(base_str, index_capture)
	return nfunc(function(_, snip)
		return string.rep(base_str, string.len(snip.captures[index_capture]))
	end)
end

M.math_opts = { condition = M.in_mathzone }

return M
