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

-- TODO: add the following snippets
-- - something for > Theorem:
-- - something for > Def:

return {
	s(
		{ trig = "[^%w]p ([%w]) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\prime {<>}" .. postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "[^%w]b ([%w]) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\bar {<>}" .. postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "[^%w]h ([%w]) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\hat {<>}" .. postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "([%a]+);([%d]+) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("{<>}_{<>}" .. postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),
			f(function(_, snip)
				return snip.captures[2]
			end),
		}),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "([%a]+)'([%d]+) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("{<>}^{<>}" .. postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),
			f(function(_, snip)
				return snip.captures[2]
			end),
		}),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "vec ([%a]+) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\vec{<>}" .. postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "mr", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\sqrt[<>]{<>}" .. postspace, { i(1, "degree"), i(2, "component") }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "mt ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t("\\times" .. postspace),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "vd ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t("\\cdot" .. postspace),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "ff", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\frac {<>}{<>}" .. postspace, { i(1, "numerator"), i(2, "denominator") }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "mpro", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\prod_{<>}^{<>} <>" .. postspace, { i(1, "start"), i(2, "stop"), i(3, "equation") }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "msum", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\sum_{<>}^{<>} <>" .. postspace, { i(1, "start"), i(2, "stop"), i(3, "equation") }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "mint", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\int_{<>}^{<>} <>" .. postspace, { i(1, "start"), i(2, "stop"), i(3, "equation") }),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "mdet", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\det{<>}" .. postspace, { i(1, "elements") }),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "mmag", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("|<>|" .. postspace, { d(1, get_visual) }),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "cc", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\cancel{<>}" .. postspace, { d(1, get_visual) }),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "bmat", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta(
			[[
	\begin{bmatrix}
	<> & <> & <>\\
	<> & <> & <> \\
	<> & <> & <> \\
	\end{bmatrix}
	]],
			{ i(1, "a"), i(2, "b"), i(3, "c"), i(4, "d"), i(5, "e"), i(6, "f"), i(7, "g"), i(8, "h"), i(9, "i") }
		),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "bdet", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta(
			[[
	\begin{vmatrix}
	<> & <> & <>\\
	<> & <> & <> \\
	<> & <> & <> \\
	\end{vmatrix}
	]],
			{ i(1, "a"), i(2, "b"), i(3, "c"), i(4, "d"), i(5, "e"), i(6, "f"), i(7, "g"), i(8, "h"), i(9, "i") }
		),
		{ condition = in_mathzone }
	),
}
