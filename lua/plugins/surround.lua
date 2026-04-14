return {
	"kylechui/nvim-surround",
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
	init = function()
		-- Disable default keymaps before the plugin loads (see :h nvim-surround.options)
		vim.g.nvim_surround_no_mappings = true
	end,
	config = function()
		require("nvim-surround").setup({})

		-- Custom keymaps using <Plug> mappings (see :h nvim-surround.keymaps)
		vim.keymap.set("i", "<C-g>z", "<Plug>(nvim-surround-insert)", {
			desc = "Add a surrounding pair around the cursor (insert mode)",
		})
		vim.keymap.set("i", "<C-g>Z", "<Plug>(nvim-surround-insert-line)", {
			desc = "Add a surrounding pair around the cursor, on new lines (insert mode)",
		})
		vim.keymap.set("n", "yz", "<Plug>(nvim-surround-normal)", {
			desc = "Add a surrounding pair around a motion (normal mode)",
		})
		vim.keymap.set("n", "yzz", "<Plug>(nvim-surround-normal-cur)", {
			desc = "Add a surrounding pair around the current line (normal mode)",
		})
		vim.keymap.set("n", "yZ", "<Plug>(nvim-surround-normal-line)", {
			desc = "Add a surrounding pair around a motion, on new lines (normal mode)",
		})
		vim.keymap.set("n", "yZZ", "<Plug>(nvim-surround-normal-cur-line)", {
			desc = "Add a surrounding pair around the current line, on new lines (normal mode)",
		})
		vim.keymap.set("x", "Z", "<Plug>(nvim-surround-visual)", {
			desc = "Add a surrounding pair around a visual selection",
		})
		vim.keymap.set("x", "gZ", "<Plug>(nvim-surround-visual-line)", {
			desc = "Add a surrounding pair around a visual selection, on new lines",
		})
		vim.keymap.set("n", "dz", "<Plug>(nvim-surround-delete)", {
			desc = "Delete a surrounding pair",
		})
		vim.keymap.set("n", "cz", "<Plug>(nvim-surround-change)", {
			desc = "Change a surrounding pair",
		})
		vim.keymap.set("n", "cZ", "<Plug>(nvim-surround-change-line)", {
			desc = "Change a surrounding pair, putting replacements on new lines",
		})
	end,
}
