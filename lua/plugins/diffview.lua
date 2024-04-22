return {
	"sindrets/diffview.nvim",
	opts = function()
		require("diffview").setup()

		vim.keymap.set("n", "<leader>dfo", "<cmd>DiffviewOpen<CR>")
		vim.keymap.set("n", "<leader>dfc", "<cmd>DiffviewClose<CR>")
		vim.keymap.set("n", "<leader>dfh", "<cmd>DiffviewFileHistory<CR>")
	end,
}
