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
	s({
		trig = schars .. ".([tT])h" .. psp,
		wordTrig = false,
		regTrig = true,
	}, fmta([[<>\<>heta]] .. psp, { ncapture(1), ncapture(2) }), mopts),

	s(
		{ trig = schars .. ".([dD])e" .. psp, wordTrig = false, regTrig = true },
		fmta([[<>\<>elta]] .. psp, { ncapture(1), ncapture(2) }),
		mopts
	),

	s(
		{ trig = schars .. ".([pP])h" .. psp, wordTrig = false, regTrig = true },
		fmta([[<>\<>hi]] .. psp, { ncapture(1), ncapture(2) }),
		mopts
	),

	s(
		{ trig = schars .. "inf", wordTrig = false, regTrig = true },
		fmta([[<>\infty]] .. psp, { ncapture(1) }),
		mopts
	),
}
