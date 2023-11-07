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
		trig = schars .. "cos" .. psp,
		wordTrig = false,
		regTrig = true,
	}, fmta([[<>\cos]] .. psp, { ncapture(1) }), mopts),

	s({
		trig = schars .. "sin" .. psp,
		wordTrig = false,
		regTrig = true,
	}, fmta([[<>\sin]] .. psp, { ncapture(1) }), mopts),

	s({
		trig = schars .. "tan" .. psp,
		wordTrig = false,
		regTrig = true,
	}, fmta([[<>\tan]] .. psp, { ncapture(1) }), mopts),

	s({
		trig = schars .. "sec" .. psp,
		wordTrig = false,
		regTrig = true,
	}, fmta([[<>\sec]] .. psp, { ncapture(1) }), mopts),

	s({
		trig = schars .. "csc" .. psp,
		wordTrig = false,
		regTrig = true,
	}, fmta([[<>\csc]] .. psp, { ncapture(1) }), mopts),

	s({
		trig = schars .. "cot" .. psp,
		wordTrig = false,
		regTrig = true,
	}, fmta([[<>\cot]] .. psp, { ncapture(1) }), mopts),

	s({
		trig = schars .. "acos" .. psp,
		wordTrig = false,
		regTrig = true,
	}, fmta([[<>\arccos]] .. psp, { ncapture(1) }), mopts),

	s({
		trig = schars .. "asin" .. psp,
		wordTrig = false,
		regTrig = true,
	}, fmta([[<>\arcsin]] .. psp, { ncapture(1) }), mopts),

	s({
		trig = schars .. "atan" .. psp,
		wordTrig = false,
		regTrig = true,
	}, fmta([[<>\arctan]] .. psp, { ncapture(1) }), mopts),
}
