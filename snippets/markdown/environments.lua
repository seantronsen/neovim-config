local ls = require("luasnip")
local s = ls.snippet
local ntext = ls.text_node
local ninsert = ls.insert_node

local nfunc = ls.function_node
local ndynamic = ls.dynamic_node
local rep = require("luasnip.extras").rep
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
		trig = schars .. "tag" .. psp,
		wordTrig = false,
		regTrig = true,
	}, fmta([[<>\tag{ <> }]] .. psp, { ncapture(1), ninsert(1) }), mopts),

	s(
		{ trig = "^bpe " .. tchars .. psp, wordTrig = false, regTrig = true },
		fmta(
			[[
			```<>

			<>

			```
	]],
			{ ncapture(1), ninsert(1, "code content") }
		),
		{ condition = ut.not_mathzone }
	),

	s(
		{ trig = "^bme", wordTrig = false, regTrig = true },
		fmta(
			[[
	$$
	<>
	$$
	]],
			{ ninsert(1, "content") }
		),
		{ condition = ut.not_mathzone }
	),

	s(
		{ trig = schars .. "bmi", wordTrig = false, regTrig = true },
		fmta([[<>$<>$]] .. psp, { ncapture(1), ninsert(1, "content") }),
		{ condition = ut.not_mathzone }
	),

	s(
		{ trig = "^benv", wordTrig = false, regTrig = true },
		fmta(
			[[
	\begin{<>}

	<>

	\end{<>}
	]],
			{ ninsert(1, "section-type"), ninsert(2, "content"), rep(1) }
		),
		mopts
	),

	s(
		{ trig = "^beq", wordTrig = false, regTrig = true },
		fmta(
			[[
	\begin{equation}

	<>

	\end{equation}
	]],
			{ ninsert(1, "content") }
		),
		mopts
	),

	s(
		{ trig = "^bali", wordTrig = false, regTrig = true },
		fmta(
			[[
	\begin{align}

	<>

	\end{align}
	]],
			{ ninsert(1, "content") }
		),
		mopts
	),
	s(
		{ trig = "^bcas", wordTrig = false, regTrig = true },
		fmta(
			[[
	\begin{cases}

	<>

	\end{cases}
	]],
			{ ninsert(1, "content") }
		),
		mopts
	),
}

-- there is an issue with the bmi snippet as it occurs within the middle of a word
-- this may hint at other snippets needed review as well.
