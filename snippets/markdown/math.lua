local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node

local f = ls.function_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local snutils = require("core.snippetutils")

return {
	s(
		{ trig = "[^%w]p ([%w\\]) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta([[{<>} \prime]] .. snutils.postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = snutils.in_mathzone }
	),
	s(
		{ trig = "[^%w]b ([%w]) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\bar {<>}" .. snutils.postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = snutils.in_mathzone }
	),
	s(
		{ trig = "[^%w]h ([%w]) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\hat {<>}" .. snutils.postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = snutils.in_mathzone }
	),

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
		{ trig = "([%a]+);([%d]+) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("{<>}_{<>}" .. snutils.postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),
			f(function(_, snip)
				return snip.captures[2]
			end),
		}),
		{ condition = snutils.in_mathzone }
	),

	s(
		{ trig = "([%a]+)'([%d]+) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("{<>}^{<>}" .. snutils.postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),
			f(function(_, snip)
				return snip.captures[2]
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
		{ trig = "cc", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\cancel{<>}" .. snutils.postspace, { d(1, get_visual) }),
		{ condition = snutils.in_mathzone }
	),

	s(
		{ trig = "perp ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\perp]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),

	-- logical operations
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
		{
			trig = snutils.nalphnum .. "lim",
			wordTrig = false,
			regTrig = true,
			snippetType = "autosnippet",
		},
		fmta([[\lim_{<> \to <>}]] .. snutils.postspace, { i(1, "a"), i(2, "b") }),
		{ condition = snutils.in_mathzone }
	),

	s(
		{
			trig = snutils.nalphnum .. "ne",
			wordTrig = false,
			regTrig = true,
			snippetType = "autosnippet",
		},
		t([[\ne]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),
	s(
		{
			trig = snutils.nalphnum .. "geq",
			wordTrig = false,
			regTrig = true,
			snippetType = "autosnippet",
		},
		t([[\geq]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),

	s(
		{
			trig = snutils.nalphnum .. "leq",
			wordTrig = false,
			regTrig = true,
			snippetType = "autosnippet",
		},
		t([[\leq]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),
	s(
		{ trig = "cap", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\cap]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),

	s(
		{ trig = "cup", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\cap]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),
	s(
		{ trig = "inf", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\infty]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),

	s(
		{ trig = "appr", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\approx]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),

	s(
		{ trig = ";pl", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\mathcal{P}]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),
}
-- add snippet for plane notation (P_1) with the weird squiggle P
-- add snippet for stackable primes (derivatives) integrals, etc.
-- snippets should include the \ symbol when consuming for easier stacking.
-- add snippet for parallel
--
--
--
--
--
