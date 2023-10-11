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

local nalphnum = "([^%w])"
local postspace = " "

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
		{ condition = not_mathzone }
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
		{ condition = not_mathzone }
	),

	s(
		{ trig = "bmi", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("$<>$" .. postspace, { i(1, "content") }),
		{ condition = not_mathzone }
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
		{ condition = in_mathzone }
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
		{ condition = in_mathzone }
	),
}
