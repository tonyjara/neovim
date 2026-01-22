return {
	"NickvanDyke/opencode.nvim",
	dependencies = {
		-- Recommended for `ask()` and `select()`.
		-- Required for `snacks` provider.
		---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
		{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
	},
	config = function()
		---@type opencode.Opts
		vim.g.opencode_opts = {
			provider = {
				enabled = "tmux",
				tmux = {
					options = "-h", -- Vertical split (use "-h" for horizontal)
				},
			},
		}

		-- Required for `opts.events.reload`.
		vim.o.autoread = true

		-- Recommended/example keymaps.
		vim.keymap.set({ "n", "x" }, "<leader>lo", function()
			require("opencode").ask("@this: ", { submit = true })
		end, { desc = "Ask opencode…" })
		vim.keymap.set({ "n", "x" }, "<C-x>", function()
			require("opencode").select()
		end, { desc = "Execute opencode action…" })

		-- vim.keymap.set({ "n", "t" }, "<leader>ll", function()
		-- 	require("opencode").toggle()
		-- end, { desc = "Toggle opencode" })
		vim.keymap.set({ "n", "t" }, "<leader>ll", function()
			require("opencode").toggle()

			vim.defer_fn(function()
				local provider = require("opencode.config").provider
				if provider and provider.name == "tmux" then
					local pane_id = provider:get_pane_id()
					if pane_id then
						vim.fn.system("tmux select-pane -t " .. pane_id)
					end
				end
			end, 50)
		end, { desc = "Toggle opencode and focus" })

		vim.keymap.set({ "n", "x" }, "go", function()
			return require("opencode").operator("@this ")
		end, { desc = "Add range to opencode", expr = true })

		vim.keymap.set("v", "<leader>la", function()
			vim.defer_fn(function()
				local provider = require("opencode.config").provider
				if provider and provider.name == "tmux" then
					local pane_id = provider:get_pane_id()
					if pane_id then
						vim.fn.system("tmux select-pane -t " .. pane_id)
					end
				end
			end, 50)
			return require("opencode").operator("@this ") .. "_"
		end, { desc = "Add line to opencode", expr = true })

		vim.keymap.set("n", "<S-C-u>", function()
			require("opencode").command("session.half.page.up")
		end, { desc = "Scroll opencode up" })
		vim.keymap.set("n", "<S-C-d>", function()
			require("opencode").command("session.half.page.down")
		end, { desc = "Scroll opencode down" })

		-- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
		vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
		vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
	end,
}
