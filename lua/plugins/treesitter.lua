return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local configs = require("nvim-treesitter.configs")

		vim.treesitter.language.register("bash", "sh")
		vim.treesitter.language.register("markdown", "mdx")

		--[[ local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername ]]
		--[[ ft_to_parser.mdx = "markdown" ]]
		configs.setup({
			ensure_installed = {
				"astro",
				"bash",
				"c",
				"css",
				"vimdoc",
				"html",
				"http",
				"javascript",
				"json",
				"jsdoc",
				"lua",
				"markdown",
				"markdown_inline",
				"prisma",
				"python",
				"tsx",
				"svelte",
				"typescript",
				"vim",
				"yaml",
				-- These don't work
				--[[ "pyright", ]]
				--[[ "mypy", ]]
				--[[ "ruff", ]]
				--[[ "black", ]]
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
			ignore_install = { "haskell" },
			modules = {},
			sync_install = true,
			auto_install = true,
			autopairs = {
				enable = true,
			},
			highlight = {
				enable = true, -- false will disable the whole extension
				disable = {}, -- list of language that will be disabled
				additional_vim_regex_highlighting = true,
			},
			indent = {
				enable = true,
			},
			-- autotag = {
			-- 	enable = true,
			-- },
		})
	end,
}
