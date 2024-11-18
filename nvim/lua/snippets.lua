local ls = require("luasnip")

ls.add_snippets(nil, {
	all = {
		ls.parser.parse_snippet("expand", "-- TEST SNIPPET"),
	},
	css = {
		ls.parser.parse_snippet("ax", "var(--ax-$1);$0"),
	},
})
