return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"jose-elias-alvarez/typescript.nvim",
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				--only to get that nice import all
				require("typescript.extensions.null-ls.code-actions"),
				require("none-ls.code_actions.eslint_d"),
				-- null_ls.builtins.formatting.eslint_d.with({
				-- 	filetypes = {
				-- 		"javascript",
				-- 		"typescript",
				-- 		"typescriptreact",
				-- 		"javascriptreact",
				-- 		"astro",
				-- 		"css",
				-- 		"scss",
				-- 		"html",
				-- 		"json",
				-- 		"yaml",
				-- 		"markdown",
				-- 		"graphql",
				-- 		"md",
				-- 		"txt",
				-- 	},
				-- }),
			},
		})
	end,
}
