local ls = require("luasnip")
local s = ls.snippet
local ntext = ls.text_node
local ninsert = ls.insert_node

local nfunc = ls.function_node
local ndynamic = ls.dynamic_node
local nrep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta
local fmt = require("luasnip.extras.fmt").fmt

local snutils = require("core.snippetutils")
local markdown_header = [[> [!{}] {}
>
> ]]

return {}, {
	s(
		{ trig = "^sthe", wordTrig = false, regTrig = true },
		fmt(markdown_header, { ntext("important"), ntext("Theorem") }),
		{ condition = snutils.not_mathzone }
	),
	s(
		{ trig = "^sdef", wordTrig = false, regTrig = true },
		fmt(markdown_header, { ntext("important"), ntext("Definition") }),
		{ condition = snutils.not_mathzone }
	),
	s(
		{ trig = "^snot", wordTrig = false, regTrig = true },
		fmt(markdown_header, { ntext("info"), ntext("Note") }),
		{ condition = snutils.not_mathzone }
	),

	s(
		{ trig = "^swar", wordTrig = false, regTrig = true },
		fmt(markdown_header, { ntext("warning"), ntext("") }),
		{ condition = snutils.not_mathzone }
	),

	s(
		{ trig = "^s!", wordTrig = false, regTrig = true },
		fmt(markdown_header, { ntext("important"), ntext("") }),
		{ condition = snutils.not_mathzone }
	),

	s(
		{ trig = "^s%?", wordTrig = false, regTrig = true },
		fmt(markdown_header, { ntext("faq"), ntext("Common Questions") }),
		{ condition = snutils.not_mathzone }
	),

	s(
		{ trig = "^serr", wordTrig = false, regTrig = true },
		fmt(markdown_header, { ntext("fail"), ntext("") }),
		{ condition = snutils.not_mathzone }
	),
}
