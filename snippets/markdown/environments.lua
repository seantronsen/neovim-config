local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local f = ls.function_node
local d = ls.dynamic_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

local snutils = require("core.snippetutils")

return {

	s(
		{ trig = "bpe ([%w]+) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta(
			[[
			```<>

			<>

			```
	]],
			{

				f(function(_, snip)
					return snip.captures[1]
				end),

				i(1, "code content"),
			}
		),
		{ condition = snutils.not_mathzone }
	),

	s(
		{ trig = "bme", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta(
			[[
	$$
	<>
	$$
	]],
			{ i(1, "content") }
		),
		{ condition = snutils.not_mathzone }
	),

	s(
		{ trig = "bmi", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("$<>$" .. snutils.postspace, { i(1, "content") }),
		{ condition = snutils.not_mathzone }
	),

	s(
		{ trig = "benv", snippetType = "autosnippet" },
		fmta(
			[[
	\begin{<>}

	<>

	\end{<>}
	]],
			{ i(1, "section-type"), i(2, "content"), rep(1) }
		),
		{ condition = snutils.in_mathzone }
	),

	s(
		{ trig = "beq", snippetType = "autosnippet" },
		fmta(
			[[
	\begin{equation}

	<>

	\end{equation}
	]],
			{ i(1, "content") }
		),
		{ condition = snutils.in_mathzone }
	),
}

-- there is an issue with the bmi snippet as it occurs within the middle of a word
-- this may hint at other snippets needed review as well.
