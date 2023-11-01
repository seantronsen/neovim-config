local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local f = ls.function_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

local snutils = require("core.snippetutils")

return {

	s(
		{ trig = "perp ", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		t([[\perp]] .. snutils.postspace),
		{ condition = snutils.in_mathzone }
	),
}
