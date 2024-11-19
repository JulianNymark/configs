local ls = require("luasnip")
local extras = require("luasnip.extras")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt
local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node

local snippets = {
	["```"] = ls.parser.parse_snippet("```", "```\n$0\n```"),
}

ls.add_snippets(nil, {
	all = {
		ls.parser.parse_snippet("snippet", "TEST SNIPPET all"),
	},
	css = {
		ls.parser.parse_snippet("ax", "var(--ax-$1);$0"),
	},
})

vim.keymap.set("n", "<Leader><Leader>`", function()
	ls.snip_expand(snippets["```"])
end)
