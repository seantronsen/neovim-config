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

return {

	s(
		"bme",
		fmta(
			[[
	$$
	<>
	$$
	]],
			{ i(1, "content") }
		)
	),
	s("bmi", fmta("$<>$", { i(1, "content") })),
	s(
		"benv",
		fmta(
			[[
	\begin{<>}

	<>

	\end{<>}
	]],
			{ i(1, "section-type"), i(2, "content"), rep(1) }
		)
	),
	s(
		"beq",
		fmta(
			[[
	\begin{equation}

	<>

	\end{equation}
	]],
			{ i(1, "content") }
		)
	),
	s("mv", fmta("\vec{<>} ", { i(1, "variable") })),
	s("mr", fmta("\\sqrt[<>]{<>} ", { i(1, "degree"), i(2, "component") })),
	s("mt", t("\\times")),
	s("vd", t("\\cdot")),
	s("mf", fmta("\frac {<>}{<>} ", { i(1, "numerator"), i(2, "denominator") })),
	s("mpro", fmta("\\prod_{<>}^{<>} <>", { i(1, "start"), i(2, "stop"), i(3, "equation") })),
	s("msum", fmta("\\sum_{<>}^{<>} <>", { i(1, "start"), i(2, "stop"), i(3, "equation") })),
	s("mint", fmta("\\int_{<>}^{<>} <>", { i(1, "start"), i(2, "stop"), i(3, "equation") })),

	s(
		"bbm",
		fmta(
			[[
	\begin{bmatrix}
	<> \\
	<>
	\end{bmatrix}
	]],
			{ i(1, "row_00"), i(2, "row_01") }
		)
	),
	s(
		"bdm",
		fmta(
			[[
	\begin{Vmatrix}
	<> \\
	<>
	\end{Vmatrix}
	]],
			{ i(1, "row_00"), i(2, "row_01") }
		)
	),
}
