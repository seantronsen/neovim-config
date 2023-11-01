local ls = require("luasnip")
local snutils = require("core.snippetutils")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta


return {
	s(
		{ trig = ";th", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\theta]]),
		{ condition = snutils.in_mathzone }
	),
	s(
		{ trig = ";Del", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\Delta]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),
	s(
		{ trig = ";del", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\delta]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),
	s(
		{ trig = ";phi", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\phi]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),

	s(
		{ trig = "inf", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\infty]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),
}
