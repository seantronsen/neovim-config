local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local f = ls.function_node
local d = ls.dynamic_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

local snutils = require("core.snippetutils")

return {
	s(
		{ trig = "sthe ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[> Theorem: ]]),
		{ condition = snutils.not_mathzone }
	),
	s(
		{ trig = "sdef ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[> Definition: ]]),
		{ condition = snutils.not_mathzone }
	),
}
