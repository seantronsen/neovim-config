local ls = require("luasnip")
local sn = ls.snippet_node
local i = ls.insert_node

local get_visual = function(_, parent)
	if #parent.snippet.env.LS_SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
	else -- If LS_SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end

local in_mathzone = function()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

local not_mathzone = function()
	return not in_mathzone()
end

local nalphnum = "([^%w])"
local postspace = " "

return {
	nalphnum,
	postspace,
	get_visual,
	in_mathzone,
	not_mathzone,
}
