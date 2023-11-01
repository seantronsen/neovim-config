local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

local snutils = require("core.snippetutils")

return {
	s(
		{
			trig = "tfi",
			dscr = "Expands 'tfi' into LaTeX's textit{} command.",
			snippetType = "autosnippet",
		},
		fmta("\\textit{<>}" .. snutils.postspace, {
			d(1, snutils.get_visual),
		})
	),
	s(
		{
			trig = "tfb",
			dscr = "Expands 'tfb' into LaTeX's textbf{} command.",
			snippetType = "autosnippet",
		},
		fmta("\\textbf{<>}" .. snutils.postspace, {
			d(1, snutils.get_visual),
		})
	),
	s(
		{
			trig = "tfn",
			dscr = "Expands 'tfn' into LaTeX's text{} command.",
			snippetType = "autosnippet",
		},
		fmta("\\text{<>}" .. snutils.postspace, {
			d(1, snutils.get_visual),
		})
	),

	s(
		{ trig = "nl", dscr = "latex math newline", snippetType = "autosnippet" },
		t([[\\]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),
}
