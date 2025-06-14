return {
	"moll/vim-bbye",
	config = function()
		local map = vim.keymap.set
		local opts = { noremap = true, silent = true }

		opts.desc = "Clear all buffers and splits"
		map("n", "<leader>bk", "<cmd>%bd<cr><cmd>Bdelete<cr>", opts)

		opts.desc = "Clear all buffers and splits but the one where the cursor is"
		map("n", "<leader>bi", "<cmd>%bd|e#<cr>", opts)

		opts.desc = "Close current buffer"
		map("n", "∑", "<cmd>Bdelete<cr>", opts) --close buffer
	end,
}
