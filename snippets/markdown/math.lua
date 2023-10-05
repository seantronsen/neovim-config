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

return {
	s(
		{ trig = "[^%w]p ([%w\\]) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta([[{<>} \prime]] .. postspace, {
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
		{ trig = "inv ([%a]+) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("{<>}^{-1}" .. postspace, {
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
		{ trig = "vec ([^%s]+)[ ]+", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\vec{<>}" .. postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "vec2", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta(
			[[
	\begin{bmatrix}
	<> \\
	<> \\
	\end{bmatrix}
	]],
			{ i(1, "a"), i(2, "b") }
		),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "vec3", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta(
			[[
	\begin{bmatrix}
	<> \\
	<> \\
	<> \\
	\end{bmatrix}
	]],
			{ i(1, "a"), i(2, "b"), i(3, "c") }
		),
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
		{ trig = "df", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\frac {d <>}{d <>}" .. postspace, { i(1, "numerator"), i(2, "denominator") }),
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
		fmta("\\det{(<>)}" .. postspace, { i(1, "elements") }),
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
		{ trig = "imat9", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[
	\begin{bmatrix}
	1 & 0 & 0 \\
	0 & 1 & 0 \\
	0 & 0 & 1 \\
	\end{bmatrix}
	]]),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "bmat9", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
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
		{ trig = "imat4", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[
	\begin{bmatrix}
	1 & 0  \\
	0 & 1  \\
	\end{bmatrix}
	]]),
		{ condition = in_mathzone }
	),

	s(
		{
			trig = "bmat4",
			wordTrig = false,
			regTrig = true,
			snippetType = "autosnippet",
		},
		fmta(
			[[
	\begin{bmatrix}
	<> & <> \\
	<> & <> \\
	\end{bmatrix}
	]],
			{ i(1, "a"), i(2, "b"), i(3, "c"), i(4, "d") }
		),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "bdet9", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
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

	s(
		{
			trig = "bdet4",
			wordTrig = false,
			regTrig = true,
			snippetType = "autosnippet",
		},
		fmta(
			[[
	\begin{vmatrix}
	<> & <> \\
	<> & <> \\
	\end{vmatrix}
	]],
			{ i(1, "a"), i(2, "b"), i(3, "c"), i(4, "d") }
		),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "perp ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\perp]] .. postspace),
		{ condition = in_mathzone }
	),

	-- logical operations
	s(
		{ trig = "[%s]+imp ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\implies]] .. postspace),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "ifof ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\iff]] .. postspace),
		{ condition = in_mathzone }
	),

	s(
		{ trig = ";th", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\theta]]),
		{ condition = in_mathzone }
	),

	s(
		{ trig = ";del", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\delta]] .. postspace),
		{ condition = in_mathzone }
	),
	s(
		{ trig = ";phi", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\phi]] .. postspace),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "ne", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\ne]] .. postspace),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "cap", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\cap]] .. postspace),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "cup", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\cap]] .. postspace),
		{ condition = in_mathzone }
	),
	s(
		{ trig = "inf", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\infty]] .. postspace),
		{ condition = in_mathzone }
	),

	s(
		{ trig = "appr", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\approx]] .. postspace),
		{ condition = in_mathzone }
	),


	s(
		{ trig = ";pl", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\mathcal{P}]] .. postspace),
		{ condition = in_mathzone }
	),

}
-- add snippet for plane notation (P_1) with the weird squiggle P
-- add snippet for stackable primes (derivatives) integrals, etc.
-- snippets should include the \ symbol when consuming for easier stacking.
-- add snippet for parallel
