return {
	"kdheepak/lazygit.nvim",
	config = function()
		local map = vim.api.nvim_set_keymap
		map("n", "<leader>lg", "<cmd>:LazyGit<CR>", { noremap = true, silent = true, desc = "LazyGit" })
	end,
}
