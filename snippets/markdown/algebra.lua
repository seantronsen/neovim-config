local ls = require("luasnip")
local s = ls.snippet
local ntext = ls.text_node
local ninsert = ls.insert_node

local nfunc = ls.function_node
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
	s(
		{ trig = schars .. "mr" .. psp, wordTrig = false, regTrig = true },
		fmta(
			[[<>\sqrt[<>]{ <> }]] .. psp,
			{ ncapture(1), ninsert(1, "degree"), ninsert(2, "component") }
		),
		mopts
	),
	s(
		{ trig = schars .. "mt" .. psp, wordTrig = false, regTrig = true },
		fmta([[<>\times]] .. psp, { ncapture(1) }),
		mopts
	),
	s(
		{ trig = schars .. "ff" .. psp, wordTrig = false, regTrig = true },
		fmta(
			[[<>\frac { <> }{ <> }]] .. psp,
			{ ncapture(1), ninsert(1, "numerator"), ninsert(2, "denominator") }
		),
		mopts
	),
}
