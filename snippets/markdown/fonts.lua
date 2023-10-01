local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node

local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local in_mathzone = function()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

local not_mathzone = function()
	return not in_mathzone()
end

local get_visual = function(_, parent)
	if #parent.snippet.env.LS_SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
	else -- If LS_SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end

local nalphnum = "([^%w])"
local postspace = " "

return {
	s(
		{ trig = "tfi", dscr = "Expands 'tfi' into LaTeX's textit{} command.", snippetType = "autosnippet" },
		fmta("\\textit{<>}" .. postspace, {
			d(1, get_visual),
		})
	),
	s(
		{ trig = "tfb", dscr = "Expands 'tfb' into LaTeX's textbf{} command.", snippetType = "autosnippet" },
		fmta("\\textbf{<>}" .. postspace, {
			d(1, get_visual),
		})
	),
	s(
		{ trig = "tfn", dscr = "Expands 'tfn' into LaTeX's text{} command.", snippetType = "autosnippet" },
		fmta("\\text{<>}" .. postspace, {
			d(1, get_visual),
		})
	),

	s(
		{ trig = "nl", dscr = "latex math newline", snippetType = "autosnippet" },
		t([[\\]] .. postspace),
		{ condition = in_mathzone }
	),
}
