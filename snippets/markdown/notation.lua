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
		trig = schars .. "([p]+) " .. tchars .. psp,
		wordTrig = false,
		regTrig = true,
		desc = "expr -> prime",
	}, fmta([[<>{<>}<>]] .. psp, { ncapture(1), ncapture(3), ncapturestack([[\prime]], 2) }), mopts),

	s(
		{ trig = schars .. "b " .. tchars .. psp, wordTrig = false, regTrig = true },
		fmta([[<>\bar {<>}]] .. psp, { ncapture(1), ncapture(2) }),
		mopts
	),

	s(
		{ trig = schars .. "h " .. tchars .. psp, wordTrig = false, regTrig = true },
		fmta([[<>\hat {<>}]] .. psp, { ncapture(1), ncapture(2) }),
		mopts
	),

	s({
		trig = tchars .. ";" .. tchars .. psp,
		wordTrig = false,
		regTrig = true,
		desc = "suffix to subscript",
	}, fmta("{<>}_{<>}" .. psp, { ncapture(1), ncapture(2) }), mopts),

	s({
		trig = tchars .. "'" .. tchars .. psp,
		wordTrig = false,
		regTrig = true,
		desc = "suffix to superscript",
	}, fmta([[{<>}^{<>}]] .. psp, { ncapture(1), ncapture(2) }), mopts),

	s(
		{ trig = "cc", wordTrig = false, regTrig = true },
		fmta([[\cancel{<>}]] .. psp, { nvisual(1) }),
		mopts
	),

	s({ trig = ";pl", wordTrig = false, regTrig = true }, ntext([[\mathcal{P}]]), mopts),
}
