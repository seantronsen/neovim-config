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
		{ trig = schars .. "df" .. psp, wordTrig = false, regTrig = true },
		fmta(
			[[<>\frac {d <>}{d <>}]] .. psp,
			{ ncapture(1), ninsert(1, "numerator"), ninsert(2, "denominator") }
		),
		mopts
	),

	s(
		{ trig = schars .. "pdf" .. psp, wordTrig = false, regTrig = true },
		fmta(
			[[<>\frac {\partial  <>}{\partial  <>}]] .. psp,
			{ ncapture(1), ninsert(1, "numerator"), ninsert(2, "denominator") }
		),
		mopts
	),

	s(
		{ trig = schars .. "pd" .. psp, wordTrig = false, regTrig = true },
		fmta([[<>\partial]] .. psp, { ncapture(1) }),
		mopts
	),

	s(
		{ trig = schars .. "mpro" .. psp, wordTrig = false, regTrig = true },
		fmta(
			[[<>\prod_{<>}^{<>} { <> }]] .. psp,
			{ ncapture(1), ninsert(1, "start"), ninsert(2, "stop"), ninsert(3, "equation") }
		),
		mopts
	),
	s(
		{ trig = schars .. "msum" .. psp, wordTrig = false, regTrig = true },
		fmta(
			[[<>\sum_{<>}^{<>} { <> }]] .. psp,
			{ ncapture(1), ninsert(1, "start"), ninsert(2, "stop"), ninsert(3, "equation") }
		),
		mopts
	),
	s(
		{ trig = schars .. "mint" .. psp, wordTrig = false, regTrig = true },
		fmta(
			[[<>\int_{<>}^{<>} { <> }]] .. psp,
			{ ncapture(1), ninsert(1, "start"), ninsert(2, "stop"), ninsert(3, "equation") }
		),
		mopts
	),

	s(
		{ trig = schars .. "lim" .. psp, wordTrig = false, regTrig = true },
		fmta([[<>\lim_{<> \to <>}]] .. psp, { ncapture(1), ninsert(1, "a"), ninsert(2, "b") }),
		mopts
	),
}
