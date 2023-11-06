local ls = require("luasnip")
local s = ls.snippet
local nsnippet = ls.snippet_node
local ntext = ls.text_node
local ninsert = ls.insert_node

local nfunc = ls.function_node
local ndynamic = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local nrep = require("luasnip.extras").rep

local ut = require("core.snippetutils")
local schars = ut.captschars
local ncapture = ut.ncapture
local ncapturestack = ut.ncapturestack
local nvisual = ut.nvisual
local psp = ut.postspace
local mopts = ut.math_opts
local tchars = ut.capttchars

return {}, {

	s(
		{ trig = "vec " .. tchars .. psp, wordTrig = false, regTrig = true },
		fmta([[\vec{ <> }]] .. psp, {
			ncapture(1),
		}),
		mopts
	),

	s(
		{ trig = "vecu " .. tchars .. psp, wordTrig = false, regTrig = true },
		fmta([[\hat {\vec{ <> }}]] .. psp, {
			ncapture(1),
		}),
		mopts
	),

	s(
		{ trig = "^vec2", wordTrig = false, regTrig = true },
		fmta(
			[[
	\begin{bmatrix}
	<> \\
	<> \\
	\end{bmatrix}
	]],
			{ ninsert(1, "a"), ninsert(2, "b") }
		),
		mopts
	),

	s(
		{ trig = "^vec3", wordTrig = false, regTrig = true },
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
		mopts
	),

	s(
		{ trig = schars .. "vd" .. psp, wordTrig = false, regTrig = true },
		fmta([[<>\cdot]] .. psp, { ncapture(1) }),
		mopts
	),

	s(
		{ trig = schars .. "mdet", wordTrig = false, regTrig = true },
		fmta([[<>\det{( <> )}]] .. psp, { ncapture(1), ninsert(1, "elements") }),
		mopts
	),

	s(
		{ trig = schars .. "mmag", wordTrig = false, regTrig = true },
		fmta("<>| <> |" .. psp, { ncapture(1), nvisual(1) }),
		mopts
	),

	s(
		{ trig = "^imat9", wordTrig = false, regTrig = true },
		ntext([[
	\begin{bmatrix}
	1 & 0 & 0 \\
	0 & 1 & 0 \\
	0 & 0 & 1 \\
	\end{bmatrix}
	]]),
		mopts
	),

	s(
		{ trig = "^bmat9", wordTrig = false, regTrig = true },
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
		mopts
	),

	s(
		{ trig = "^imat4", wordTrig = false, regTrig = true },
		ntext([[
	\begin{bmatrix}
	1 & 0  \\
	0 & 1  \\
	\end{bmatrix}
	]]),
		mopts
	),

	s(
		{
			trig = "^bmat4",
			wordTrig = false,
			regTrig = true,
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
		mopts
	),

	s(
		{ trig = "^bdet9", wordTrig = false, regTrig = true },
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
		mopts
	),

	s(
		{
			trig = "^bdet4",
			wordTrig = false,
			regTrig = true,
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
		mopts
	),
}
