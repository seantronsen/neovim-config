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
			trig = [[([%W]+)([p]+) ([%S]+) ]],
			wordTrig = false,
			regTrig = true,
			snippetType = "autosnippet",
		},
		fmta([[<>{<>} <>]] .. snutils.postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),

			f(function(_, snip)
				return snip.captures[3]
			end),

			f(snutils.charstackrep([[\prime]], 2)),
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
		{ trig = "cc", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\cancel{<>}" .. snutils.postspace, { d(1, snutils.get_visual) }),
		{ condition = snutils.in_mathzone }
	),

	s(
		{ trig = ";pl", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\mathcal{P}]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),
}
