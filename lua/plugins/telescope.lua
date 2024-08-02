return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	lazy = false,
	dependencies = {
		{ "nvim-telescope/telescope-fzf-native.nvim", "nvim-lua/plenary.nvim" },
	},
	config = function()
		local builtin = require("telescope.builtin")

		-- Table to store the last search query
		local last_search = {}
		local function start_live_grep()
			builtin.live_grep({
				attach_mappings = function(_, map)
					map("i", "<CR>", function(prompt_bufnr)
						local action_state = require("telescope.actions.state")
						local current_picker = action_state.get_current_picker(prompt_bufnr)
						local prompt_text = current_picker:_get_prompt()

						-- Store the last query
						last_search.query = prompt_text

						-- Confirm selection without closing and reopening
						require("telescope.actions").select_default(prompt_bufnr)
					end)
					return true
				end,
			})
		end

		-- Function to resume the last live_grep search
		local function resume_live_grep()
			if last_search.query then
				builtin.live_grep({
					default_text = last_search.query,
				})
			else
				print("No previous search found!")
			end
		end

		vim.keymap.set("n", "<leader>fg", start_live_grep, { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>fr", resume_live_grep, { noremap = true, silent = true })

		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
		-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
		-- vim.keymap.set("n", "<leader>fr", builtin.resume, {})
		vim.keymap.set("n", "<leader>fy", builtin.search_history, {})
		vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
		vim.keymap.set("n", "<leader>ht", builtin.colorscheme, {})
		vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, {})

		require("telescope").setup({
			defaults = {
				file_ignore_patterns = {
					"node_modules",
					"build",
					-- dist",
					"yarn.lock",
					"pnpm.lock",
					"package-lock",
					".git/",
					"lazy.lock",
					"prisma.migrations/",
					"automatic_backups/",
				},
			},
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				},
			},
		})

		-- require("telescope").load_extension("notify")
		require("telescope").load_extension("fzf")
		-- require("telescope").load_extension "file_browser"
	end,
}
