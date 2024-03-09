return {
	"akinsho/nvim-bufferline.lua",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local bufferline = require("bufferline")

		local map = vim.api.nvim_set_keymap
		local opts = { noremap = true, silent = true }

		opts.desc = "Move to previous/next buffer"
		map("n", "˙", "<Cmd>BufferLineCyclePrev<CR>", opts)

		opts.desc = "Move to previous/next buffer"
		map("n", "¬", "<Cmd>BufferLineCycleNext<CR>", opts)

		opts.desc = "Split vertically and go to next buffer"
		map("n", "<leader>]", "<cmd>vsplit<CR><C-w>p<cmd>BufferLineCyclePrev<CR><C-w>p", opts)

		opts.desc = "Go to definition in a split"
		map("n", "<leader>v]", "<cmd>vsplit<CR><C-]>", opts)

		-- map("n", "‘", "<cmd>vsplit<CR>", opts)

		bufferline.setup({
			options = {
				buffer_close_icon = "x",
				diagnostics = "nvim_lsp",
				offsets = {
					{
						filetype = "NvimTree",
					},
				},
				separator_style = "slant",
				color_icons = true,
			},
			highlights = {
				-- Square at ends of buffer bg is the slant color, fg is the remainder
				separator = {
					fg = "#4f3661",
				},
				-- same as separator but for selected buffers
				separator_selected = {
					fg = "#4f3661",
				},
				buffer_selected = {
					fg = "#1cb600",
					bold = true,
				},
				fill = {
					bg = "#4f3661",
				},
			},
		})
	end,
}
