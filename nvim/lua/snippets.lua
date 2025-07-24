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

local stateSnip = ls.parser.parse_snippet("state", "const [$1, ${1/(.*)/set${1:/capitalize}/}] = useState($0);")
local refSnip = ls.parser.parse_snippet("ref", "const $1 = useRef($0);")

ls.add_snippets(nil, {
  all = {
    -- ls.parser.parse_snippet("snippet", "TEST SNIPPET all"),
  },
  css = {
    ls.parser.parse_snippet("ax", "var(--ax-$1);$0"),
  },
  javascriptreact = {
    stateSnip,
    refSnip,
  },
  typescriptreact = {
    stateSnip,
    refSnip,
  },
  rust = {
    ls.parser.parse_snippet(
      "tests",
      [[#[cfg(test)]
mod tests {
	use super::*;

	$1
}
]]
    ),
  },
})
