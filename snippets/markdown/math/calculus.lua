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
		{
			trig = snutils.nalphnum .. "df",
			wordTrig = false,
			regTrig = true,
			snippetType = "autosnippet",
		},
		fmta(
			[[\frac {d <>}{d <>}]] .. snutils.postspace,
			{ i(1, "numerator"), i(2, "denominator") }
		),
		{ condition = snutils.in_mathzone }
	),

	s(
		{
			trig = snutils.nalphnum .. "pdf",
			wordTrig = false,
			regTrig = true,
			snippetType = "autosnippet",
		},
		fmta(
			[[\frac {\partial  <>}{\partial  <>}]] .. snutils.postspace,
			{ i(1, "numerator"), i(2, "denominator") }
		),
		{ condition = snutils.in_mathzone }
	),

	s({
		trig = snutils.nalphnum .. "pd" .. snutils.postspace,
		wordTrig = false,
		regTrig = true,
		snippetType = "autosnippet",
	}, t([[\partial]] .. snutils.postspace), { condition = snutils.in_mathzone }),

	s(
		{ trig = "mpro", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta(
			"\\prod_{<>}^{<>} <>" .. snutils.postspace,
			{ i(1, "start"), i(2, "stop"), i(3, "equation") }
		),
		{ condition = snutils.in_mathzone }
	),
	s(
		{ trig = "msum", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta(
			"\\sum_{<>}^{<>} <>" .. snutils.postspace,
			{ i(1, "start"), i(2, "stop"), i(3, "equation") }
		),
		{ condition = snutils.in_mathzone }
	),
	s(
		{ trig = "mint", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta(
			"\\int_{<>}^{<>} <>" .. snutils.postspace,
			{ i(1, "start"), i(2, "stop"), i(3, "equation") }
		),
		{ condition = snutils.in_mathzone }
	),

	s(
		{
			trig = snutils.nalphnum .. "lim",
			wordTrig = false,
			regTrig = true,
			snippetType = "autosnippet",
		},
		fmta([[\lim_{<> \to <>}]] .. snutils.postspace, { i(1, "a"), i(2, "b") }),
		{ condition = snutils.in_mathzone }
	),
}
