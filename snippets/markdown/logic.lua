local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local f = ls.function_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

local snutils = require("core.snippetutils")
local schars = snutils.captschars

return {}, {

	s(
		{ trig = "[%s]+imp ", wordTrig = false, regTrig = true },
		t([[\implies]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),

	s(
		{ trig = "ifof ", wordTrig = false, regTrig = true },
		t([[\iff]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),

	s({
		trig = schars .. "neq",
		wordTrig = false,
		regTrig = true,
	}, t([[\ne]] .. snutils.postspace), { condition = snutils.in_mathzone }),
	s({
		trig = schars .. "geq",
		wordTrig = false,
		regTrig = true,
	}, t([[\geq]] .. snutils.postspace), { condition = snutils.in_mathzone }),

	s({
		trig = schars .. "leq",
		wordTrig = false,
		regTrig = true,
	}, t([[\leq]] .. snutils.postspace), { condition = snutils.in_mathzone }),

	s(
		{ trig = "appr", wordTrig = false, regTrig = true },
		t([[\approx]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),
}
