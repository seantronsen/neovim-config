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

return {
	s("pyig", t("# pyright: ignore")),
}


-- TODO: add the following snippets
-- - mmag for magnitude
-- - something for determinant
-- - something for > Theorem:
-- - something for > Def:
--
