return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<Tab>",
				clear_suggestion = "<C-]>",
				accept_word = "<C-j>",
			},
			ignore_filetypes = { cpp = true },
			color = {
				-- suggestion_color = "#ffffff",
				cterm = 244,
			},
			log_level = "info", -- set to "off" to disable logging completely
			disable_inline_completion = false, -- disables inline completion for use with cmp
			disable_keymaps = false, -- disables built in
		})
		vim.keymap.set("n", "<leader>smt", "<cmd>SupermavenToggle<CR>", { desc = "SuperMaven Toggle" })
		vim.keymap.set("n", "<leader>sms", "<cmd>SupermavenStop<CR>", { desc = "SuperMaven Stop" })
	end,
}
