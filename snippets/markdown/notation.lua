local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local f = ls.function_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

local ut = require("core.snippetutils")
local schars = ut.captschars
local tchars = ut.capttchars
local psp = ut.postspace

return {
	s(
		{
			trig = schars .. [[([p]+) ]] .. tchars .. psp,
			wordTrig = false,
			regTrig = true,
			snippetType = "autosnippet",
			desc = "expr -> prime",
		},
		fmta([[<>{<>} <>]] .. psp, {
			f(function(_, snip)
				return snip.captures[1]
			end),

			f(function(_, snip)
				return snip.captures[3]
			end),

			f(ut.charstackrep([[\prime]], 2)),
		}),
		{ condition = ut.in_mathzone }
	),
	s(
		{ trig = "[^%w]b ([%w]) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\bar {<>}" .. ut.postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = ut.in_mathzone }
	),
	s(
		{ trig = "[^%w]h ([%w]) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\hat {<>}" .. ut.postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),
		}),
		{ condition = ut.in_mathzone }
	),

	s(
		{ trig = "([%a]+);([%d]+) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("{<>}_{<>}" .. ut.postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),
			f(function(_, snip)
				return snip.captures[2]
			end),
		}),
		{ condition = ut.in_mathzone }
	),

	s(
		{ trig = "([%a]+)'([%d]+) ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("{<>}^{<>}" .. ut.postspace, {
			f(function(_, snip)
				return snip.captures[1]
			end),
			f(function(_, snip)
				return snip.captures[2]
			end),
		}),
		{ condition = ut.in_mathzone }
	),

	s(
		{ trig = "cc", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\cancel{<>}" .. ut.postspace, { d(1, ut.get_visual) }),
		{ condition = ut.in_mathzone }
	),

	s(
		{ trig = ";pl", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\mathcal{P}]] .. ut.postspace),
		{ condition = ut.in_mathzone }
	),
}
