return {
	"L3MON4D3/LuaSnip",
	event = "InsertEnter",
	config = function()
		local ls = require("luasnip")
		local s = ls.snippet
		local t = ls.text_node
		local c = ls.choice_node
		local f = ls.function_node
		local i = ls.insert_node

		local extras = require("luasnip.extras")
		local fmt = require("luasnip.extras.fmt").fmt
		local rep = extras.rep -- To repeat text, it's basically multicursor

		-- Example for LUA
		-- ls.add_snippets("lua", {
		-- 	s("hello", {
		-- 		t('print("Hello, ")'),
		-- 		i(1),
		-- 		t(" world!"),
		-- 	}),
		-- })

		ls.add_snippets("dart", {
			s(
				"stful",
				fmt(
					[[
class {} extends StatefulWidget {{
  const {}({{super.key}});

  @override
  State<{}> createState() => _{}();
}}

class _{} extends State<{}> {{
  @override
  Widget build(BuildContext context) {{
    return {};
  }}
}}]],
					{
						i(1, "WidgetName"), -- Class name
						rep(1), -- Constructor
						rep(1), -- Generic type parameter
						rep(1), -- Private state class name
						rep(1), -- Private state class name
						rep(1), -- Generic type parameter
						i(2, "Container()"), -- Default return widget
					}
				)
			),
		})

		ls.add_snippets("dart", {
			s(
				{ trig = "stless", dscr = "Create a new Stateless Widget" },
				fmt(
					[[
class {} extends StatelessWidget {{
  const {}({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return {}(
      {}
    );
  }}
}}
      ]],
					{
						i(1, "WidgetName"),
						f(function(args)
							return args[1][1]
						end, { 1 }),
						c(2, {
							t("Container"),
							t("Scaffold"),
							t("Column"),
							t("Row"),
							t("Stack"),
						}),
						i(3),
					}
				)
			),
		})

		ls.add_snippets("dart", {
			s(
				{ trig = "inits", dscr = "Override initState method" },
				fmt(
					[[
@override
void initState() {{
  super.initState();
  {}
}}
      ]],
					{
						i(1, "// Add initialization code here"),
					}
				)
			),
		})

		ls.add_snippets("dart", {
			s(
				{ trig = "deactivates", dscr = "Override initState method" },
				fmt(
					[[
@override
void deactivate() {{
  super.deactivate();
  {}
}}
      ]],
					{
						i(1, "// Add initialization code here"),
					}
				)
			),
		})
		--
		--
		--
		--
		--
		--
	end,
}
