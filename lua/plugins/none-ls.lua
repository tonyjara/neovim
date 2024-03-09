return {
	"nvimtools/none-ls.nvim",
	dependencies = { "neovim/nvim-lspconfig", "jose-elias-alvarez/typescript.nvim" },
	config = function()
		local null_ls = require("null-ls")

		--only to get that nice import all
		null_ls.setup({
			sources = {
				require("typescript.extensions.null-ls.code-actions"),
			},
		})
	end,
}
