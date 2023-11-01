local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local f = ls.function_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

local snutils = require("core.snippetutils")

return {

	s(
		{ trig = "inv ([%a]+) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("{<>}^{-1}" .. snutils.postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = snutils.in_mathzone }
	),

	s(
		{ trig = "mr", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\sqrt[<>]{<>}" .. snutils.postspace, { i(1, "degree"), i(2, "component") }),
		{ condition = snutils.in_mathzone }
	),
	s(
		{ trig = "mt ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t("\\times" .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),

	s(
		{ trig = "ff", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\frac {<>}{<>}" .. snutils.postspace, { i(1, "numerator"), i(2, "denominator") }),
		{ condition = snutils.in_mathzone }
	),
}
