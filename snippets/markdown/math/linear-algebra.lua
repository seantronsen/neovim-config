local ls = require("luasnip")
local snutils = require("core.snippetutils")
local s = ls.snippet
local nsnippet = ls.snippet_node
local ntext = ls.text_node
local ninsert = ls.insert_node

local nfunc = ls.function_node
local ndynamic = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local nrep = require("luasnip.extras").rep


return {

	s(
		{ trig = "vec ([^%s]+)[ ]+", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\vec{<>}" .. snutils.postspace, {
			nfunc(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = snutils.in_mathzone }
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
			{ ninsert(1, "a"), ninsert(2, "b") }
		),
		{ condition = snutils.in_mathzone }
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
			{ ninsert(1, "a"), ninsert(2, "b"), ninsert(3, "c") }
		),
		{ condition = snutils.in_mathzone }
	),

	s(
		{ trig = "vd ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		ntext("\\cdot" .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),

	s(
		{ trig = "mdet", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\det{(<>)}" .. snutils.postspace, { ninsert(1, "elements") }),
		{ condition = snutils.in_mathzone }
	),

	s(
		{ trig = "mmag", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("|<>|" .. snutils.postspace, { ndynamic(1, snutils.get_visual) }),
		{ condition = snutils.in_mathzone }
	),

	s(
		{ trig = "imat9", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		ntext([[
	\begin{bmatrix}
	1 & 0 & 0 \\
	0 & 1 & 0 \\
	0 & 0 & 1 \\
	\end{bmatrix}
	]]),
		{ condition = snutils.in_mathzone }
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
				ninsert(1, "a"),
				ninsert(2, "b"),
				ninsert(3, "c"),
				ninsert(4, "d"),
				ninsert(5, "e"),
				ninsert(6, "f"),
				ninsert(7, "g"),
				ninsert(8, "h"),
				ninsert(9, "i"),
			}
		),
		{ condition = snutils.in_mathzone }
	),

	s(
		{ trig = "imat4", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		ntext([[
	\begin{bmatrix}
	1 & 0  \\
	0 & 1  \\
	\end{bmatrix}
	]]),
		{ condition = snutils.in_mathzone }
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
			{ ninsert(1, "a"), ninsert(2, "b"), ninsert(3, "c"), ninsert(4, "d") }
		),
		{ condition = snutils.in_mathzone }
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
				ninsert(1, "a"),
				ninsert(2, "b"),
				ninsert(3, "c"),
				ninsert(4, "d"),
				ninsert(5, "e"),
				ninsert(6, "f"),
				ninsert(7, "g"),
				ninsert(8, "h"),
				ninsert(9, "i"),
			}
		),
		{ condition = snutils.in_mathzone }
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
			{ ninsert(1, "a"), ninsert(2, "b"), ninsert(3, "c"), ninsert(4, "d") }
		),
		{ condition = snutils.in_mathzone }
	),
}
