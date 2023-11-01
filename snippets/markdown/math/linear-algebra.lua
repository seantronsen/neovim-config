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
		{ trig = "vd ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t("\\cdot" .. postspace),
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
			{
				i(1, "a"),
				i(2, "b"),
				i(3, "c"),
				i(4, "d"),
				i(5, "e"),
				i(6, "f"),
				i(7, "g"),
				i(8, "h"),
				i(9, "i"),
			}
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
			{
				i(1, "a"),
				i(2, "b"),
				i(3, "c"),
				i(4, "d"),
				i(5, "e"),
				i(6, "f"),
				i(7, "g"),
				i(8, "h"),
				i(9, "i"),
			}
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
}
