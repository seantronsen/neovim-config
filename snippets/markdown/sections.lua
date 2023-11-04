local ls = require("luasnip")
local s = ls.snippet
local ntext = ls.text_node
local ninsert = ls.insert_node

local nfunc = ls.function_node
local ndynamic = ls.dynamic_node
local nrep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

local snutils = require("core.snippetutils")

return {}, {
	s(
		{ trig = "^sthe", wordTrig = false, regTrig = true },
		ntext([[> Theorem: ]]),
		{ condition = snutils.not_mathzone }
	),
	s(
		{ trig = "^sdef", wordTrig = false, regTrig = true },
		ntext([[> Definition: ]]),
		{ condition = snutils.not_mathzone }
	),
	s(
		{ trig = "^snot", wordTrig = false, regTrig = true },
		ntext([[> Note: ]]),
		{ condition = snutils.not_mathzone }
	),

	s(
		{ trig = "^spro", wordTrig = false, regTrig = true },
		ntext([[### Proof: ]]),
		{ condition = snutils.not_mathzone }
	),
}
