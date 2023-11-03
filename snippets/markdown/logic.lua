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
local psp = ut.postspace
local mopts = ut.math_opts

return {}, {
	s(
		{ trig = schars .. "imp ", wordTrig = false, regTrig = true },
		fmta([[<>\implies]] .. psp, { ncapture(1) }),
		mopts
	),

	s(
		{ trig = schars .. [[ifof]], wordTrig = false, regTrig = true },
		fmta([[<>\iff]] .. psp, { ncapture(1) }),
		mopts
	),

	s(
		{ trig = schars .. "neq", wordTrig = false, regTrig = true },
		fmta([[<>\ne]] .. psp, { ncapture(1) }),
		mopts
	),

	s(
		{ trig = schars .. "geq", wordTrig = false, regTrig = true },
		fmta([[<>\geq]] .. psp, { ncapture(1) }),
		mopts
	),

	s(
		{ trig = schars .. "leq", wordTrig = false, regTrig = true },
		fmta([[<>\leq]] .. psp, { ncapture(1) }),
		mopts
	),

	s(
		{ trig = schars .. "appr", wordTrig = false, regTrig = true },
		fmta([[<>\approx]] .. psp, { ncapture(1) }),
		mopts
	),
}
