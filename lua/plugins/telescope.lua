return {
	"nvim-telescope/telescope.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-frecency.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},
	config = function()
		local builtin = require("telescope.builtin")

		require("telescope").setup({
			defaults = {
				path_display = {
					filename_first = {
						reverse_directories = true,
					},
				},

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
				frecency = {
					show_scores = true,
					-- If `true`, it shows confirmation dialog before any entries are removed from the DB
					-- If you want not to be bothered with such things and to remove stale results silently
					-- set db_safe_mode=false and auto_validate=true
					--
					-- This fixes an issue I had in which I couldn't close the floating
					-- window because I couldn't focus it
					db_safe_mode = false, -- Default: true
					-- If `true`, it removes stale entries count over than db_validate_threshold
					auto_validate = true, -- Default: true
					-- It will remove entries when stale ones exist more than this count
					db_validate_threshold = 10, -- Default: 10
					-- Show the path of the active filter before file paths.
					-- So if I'm in the `dotfiles-latest` directory it will show me that
					-- before the name of the file
					show_filter_column = false, -- Default: true
				},
			},
		})

		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "frecency")
		-- pcall(require("telescope").load_extension("notify"))
		-- require("telescope").load_extension "file_browser"

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

		-- Function to live grep with word under cursor
		local function live_grep_word_under_cursor()
			local word = vim.fn.expand("<cword>")
			builtin.live_grep({
				default_text = word,
			})
		end

		vim.keymap.set("n", "<leader>fg", start_live_grep, { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>fr", resume_live_grep, { noremap = true, silent = true })
		vim.keymap.set(
			"n",
			"<leader>fw",
			live_grep_word_under_cursor,
			{ noremap = true, silent = true, desc = "Live grep word under cursor" }
		)
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })

		-- vim.keymap.set("n", "<leader>fa",
		--     '<cmd>lua require("telescope").extensions.frecency.frecency({ sorter = require("telescope").extensions.fzf.native_fzf_sorter() })<CR>',
		--     { desc = "Find files" })

		-- vim.keymap.set("n", "<leader>fa",
		--     "<cmd>Telescope frecency workspace=CWD<cr>", { desc = "Find files" })
		-- vim.keymap.set("n", "<leader>ff",
		--     "<cmd>Telescope frecency workspace=CWD theme=ivy<cr>", { desc = "Find files" })
		-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
		-- vim.keymap.set("n", "<leader>fr", builtin.resume, {})
		vim.keymap.set("n", "<leader>fy", builtin.search_history, {})
		vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
		vim.keymap.set("n", "<leader>ht", builtin.colorscheme, {})
		vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, {})
	end,
}
