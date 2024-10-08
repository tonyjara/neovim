return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			-- Map of filetype to formatters
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				python = { "isort", "black" },
				-- Use a sub-list to run only the first available formatter
				javascript = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				astro = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				-- yaml = { { "prettier" } },
				markdown = { "prettier" },
				graphql = { "prettier" },
				md = { "prettier" },
				txt = { "prettier" },
			},
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { timeout_ms = 500, lsp_fallback = true }
			end,
			format_after_save = {
				lsp_fallback = true,
			},
			log_level = vim.log.levels.ERROR,
			notify_on_error = true,
		})
	end,
}
