return {
	"APZelos/blamer.nvim",
	config = function()
		local map = vim.keymap.set
		local opts = { noremap = true, silent = true }
		opts.desc = "Toggle Blamer"

		map("n", "<leader>bt", ":BlamerToggle<cr>", opts)
	end,
}
