local ls = require("luasnip")

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
