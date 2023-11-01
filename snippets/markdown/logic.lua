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
		{ trig = "[%s]+imp ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\implies]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),

	s(
		{ trig = "ifof ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\iff]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),

	s({
		trig = snutils.nalphnum .. "ne",
		wordTrig = false,
		regTrig = true,
		snippetType = "autosnippet",
	}, t([[\ne]] .. snutils.postspace), { condition = snutils.in_mathzone }),
	s({
		trig = snutils.nalphnum .. "geq",
		wordTrig = false,
		regTrig = true,
		snippetType = "autosnippet",
	}, t([[\geq]] .. snutils.postspace), { condition = snutils.in_mathzone }),

	s({
		trig = snutils.nalphnum .. "leq",
		wordTrig = false,
		regTrig = true,
		snippetType = "autosnippet",
	}, t([[\leq]] .. snutils.postspace), { condition = snutils.in_mathzone }),

	s(
		{ trig = "appr", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\approx]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),
}
