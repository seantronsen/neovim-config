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

-- GitLab flavored markdown headers
return {}, {
	s(
		{ trig = "^snot", wordTrig = false, regTrig = true },
		fmt(markdown_header, { ntext("note"), ntext("") }),
		{ condition = snutils.not_mathzone }
	),

	s(
		{ trig = "^s%+", wordTrig = false, regTrig = true },
		fmt(markdown_header, { ntext("tip"), ntext("") }),
		{ condition = snutils.not_mathzone }
	),

	s(
		{ trig = "^s!", wordTrig = false, regTrig = true },
		fmt(markdown_header, { ntext("important"), ntext("") }),
		{ condition = snutils.not_mathzone }
	),

	s(
		{ trig = "^scau", wordTrig = false, regTrig = true },
		fmt(markdown_header, { ntext("caution"), ntext("") }),
		{ condition = snutils.not_mathzone }
	),

	s(
		{ trig = "^swar", wordTrig = false, regTrig = true },
		fmt(markdown_header, { ntext("warning"), ntext("") }),
		{ condition = snutils.not_mathzone }
	),
	s(
		{ trig = "^s%?", wordTrig = false, regTrig = true },
		fmt(markdown_header, { ntext("caution"), ntext("Common Questions") }),
		{ condition = snutils.not_mathzone }
	),
	s(
		{ trig = "^sdef", wordTrig = false, regTrig = true },
		fmt(markdown_header, { ntext("important"), ntext("Definition") }),
		{ condition = snutils.not_mathzone }
	),
}
