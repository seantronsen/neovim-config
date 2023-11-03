local ls = require("luasnip")
local s = ls.snippet
local ntext = ls.text_node
local ndynamic = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

local ut = require("core.snippetutils")
local schars = ut.captschars
local ncapture = ut.ncapture
local ncapturestack = ut.ncapturestack
local nvisual = ut.nvisual
local psp = ut.postspace
local mopts = ut.math_opts
local tchars = ut.capttchars

return {}, {
	s({
		trig = schars .. "?i",
		wordTrig = false,
		regTrig = true,
		dscr = "equation italic text",
	}, fmta([[<>\textit{ <> }]] .. psp, { ncapture(1), nvisual(1) }), mopts),

	s({
		trig = schars .. "?b",
		wordTrig = false,
		regTrig = true,
		dscr = "equation bold text",
	}, fmta([[<>\textbf{ <> }]] .. psp, { ncapture(1), nvisual(1) }, mopts)),

	s({
		trig = schars .. "?n",
		wordTrig = false,
		regTrig = true,
		dscr = "equation normal text",
	}, fmta([[<>\text{ <> }]] .. psp, { ncapture(1), nvisual(1) }), mopts),

	s({
		trig = schars .. "n([l]+) ",
		dscr = "equation newline(s)",
		regTrig = true,
		wordTrig = false,
	}, fmta([[<><>]] .. psp, { ncapture(1), ncapturestack([[\\ ]], 2) }), mopts),
}
