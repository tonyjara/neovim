return {
	{
		"saghen/blink.compat",
		version = "*",
		lazy = true,
		opts = {},
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				name = "luasnip",
				config = function()
					-- require("luasnip.loaders.from_vscode").lazy_load()

					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_vscode").lazy_load({
						paths = { vim.fn.stdpath("config") .. "/snippets" },
					})

					local extends = {
						typescript = { "tsdoc" },
						javascript = { "jsdoc" },
						lua = { "luadoc" },
						python = { "pydoc" },
						rust = { "rustdoc" },
						cs = { "csharpdoc" },
						java = { "javadoc" },
						c = { "cdoc" },
						cpp = { "cppdoc" },
						php = { "phpdoc" },
						kotlin = { "kdoc" },
						ruby = { "rdoc" },
						sh = { "shelldoc" },
					}
					-- friendly-snippets - enable standardized comments snippets
					for ft, snips in pairs(extends) do
						require("luasnip").filetype_extend(ft, snips)
					end
				end,
			},
			{ "echasnovski/mini.icons", opts = {} },
		},
		version = "*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- See the full "keymap" documentation for information on defining your own keymap.
			keymap = {
				preset = "enter",
				["<S-Tab>"] = {},
				["<Tab>"] = {},
				["<C-l>"] = { "snippet_forward", "fallback" },
				["<C-j>"] = { "snippet_backward", "fallback" },
			},
			signature = {
				enabled = true,
				trigger = {
					enabled = false,
				},
			},

			snippets = {
				preset = "luasnip",
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "Nerd Font Mono",
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = function()
					local sources = { "lazydev", "snippets", "lsp", "path", "buffer" }

					-- if vim.tbl_contains({ "sql", "mysq", "plsql" }, vim.bo.filetype) then
					-- 	return { "dadbod", "snippets" }
					-- end
					--
					-- if vim.tbl_contains({ "markdown" }, vim.bo.filetype) then
					-- 	return { "buffer", "path", "snippets" }
					-- end

					return sources
				end,
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
					avante_commands = {
						name = "avante_commands",
						module = "blink.compat.source",
						score_offset = 90, -- show at a higher priority than lsp
						opts = {},
					},
					avante_files = {
						name = "avante_files",
						module = "blink.compat.source",
						score_offset = 100, -- show at a higher priority than lsp
						opts = {},
					},
					avante_mentions = {
						name = "avante_mentions",
						module = "blink.compat.source",
						score_offset = 1000, -- show at a higher priority than lsp
						opts = {},
					},
				},
			},
			completion = {
				accept = {},
				menu = {
					auto_show = function(ctx)
						if vim.tbl_contains({ "markdown" }, vim.bo.filetype) then
							return false
						end

						return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
					end,
				},
			},
		},
		opts_extend = { "sources.default" },
		config = function(_, opts)
			require("blink-cmp").setup(opts)
		end,
	},
}
