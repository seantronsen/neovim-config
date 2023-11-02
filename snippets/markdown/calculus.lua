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
		{
			trig = schars .. "df",
			wordTrig = false,
			regTrig = true,
		},
		fmta(
			[[\frac {d <>}{d <>}]] .. snutils.postspace,
			{ i(1, "numerator"), i(2, "denominator") }
		),
		{ condition = snutils.in_mathzone }
	),

	s(
		{
			trig = schars .. "pdf",
			wordTrig = false,
			regTrig = true,
		},
		fmta(
			[[\frac {\partial  <>}{\partial  <>}]] .. snutils.postspace,
			{ i(1, "numerator"), i(2, "denominator") }
		),
		{ condition = snutils.in_mathzone }
	),

	s({
		trig = schars .. "pd" .. snutils.postspace,
		wordTrig = false,
		regTrig = true,
	}, t([[\partial]] .. snutils.postspace), { condition = snutils.in_mathzone }),

	s(
		{ trig = "mpro", wordTrig = false, regTrig = true },
		fmta(
			"\\prod_{<>}^{<>} <>" .. snutils.postspace,
			{ i(1, "start"), i(2, "stop"), i(3, "equation") }
		),
		{ condition = snutils.in_mathzone }
	),
	s(
		{ trig = "msum", wordTrig = false, regTrig = true },
		fmta(
			"\\sum_{<>}^{<>} <>" .. snutils.postspace,
			{ i(1, "start"), i(2, "stop"), i(3, "equation") }
		),
		{ condition = snutils.in_mathzone }
	),
	s(
		{ trig = "mint", wordTrig = false, regTrig = true },
		fmta(
			"\\int_{<>}^{<>} <>" .. snutils.postspace,
			{ i(1, "start"), i(2, "stop"), i(3, "equation") }
		),
		{ condition = snutils.in_mathzone }
	),

	s(
		{
			trig = schars .. "lim",
			wordTrig = false,
			regTrig = true,
		},
		fmta([[\lim_{<> \to <>}]] .. snutils.postspace, { i(1, "a"), i(2, "b") }),
		{ condition = snutils.in_mathzone }
	),
}
