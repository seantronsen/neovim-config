local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node

local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local nalphnum = "([^%w])"
local postspace = " "

-- todo: need to add a condition that checks whether the cursor is located within comments.
-- some regex using whitespace + and the comment symbols for the language
return {

	s(
		{ trig = [[rctest]], wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta([[

		#[test]
		fn <>(){
			// arrange

			// act


			// assert


		}

		]] .. postspace, { i(1, "test_name") }),
		{}
	),
	s(
		{ trig = [[modtest]], wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta([[

		#[cfg(test)]
		mod <>tests {
			use super::*;

			// module level tests




		}

		]] .. postspace, { i(1, "module_name") }),
		{}
	),
}
