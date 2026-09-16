return {
	"nickjvandyke/opencode.nvim",
	version = "*", -- Latest stable release
	dependencies = {
		{
			-- `snacks.nvim` integration is recommended, but optional
			---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
			"folke/snacks.nvim",
			optional = true,
			opts = {
				input = {}, -- Enhances `ask()`
				picker = { -- Enhances `select()`
					actions = {
						opencode_send = function(...)
							return require("opencode").snacks_picker_send(...)
						end,
					},
					win = {
						input = {
							keys = {
								["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
							},
						},
					},
				},
			},
		},
	},
	config = function()
		---@type opencode.Opts
		vim.g.opencode_opts = {
			-- Your configuration, if any; goto definition on the type or field for details
		}

		vim.o.autoread = true -- Required for `opts.events.reload`

		-- Recommended/example keymaps
		-- vim.keymap.set({ "n", "x" }, "<C-a>", function()
		-- 	require("opencode").ask("@this: ", { submit = true })
		-- end, { desc = "Ask opencode…" })
		vim.keymap.set({ "n", "x" }, "<C-x>", function()
			require("opencode").select()
		end, { desc = "Execute opencode action…" })
		-- vim.keymap.set({ "n", "t" }, "<leader>ll", function()
		-- 	require("opencode").toggle()
		-- end, { desc = "Toggle opencode" })

		vim.keymap.set({ "n", "x" }, "go", function()
			return require("opencode").operator("@this ")
		end, { desc = "Add range to opencode", expr = true })
		vim.keymap.set("n", "<leader>la", function()
			return require("opencode").operator("@this ") .. "_"
		end, { desc = "Add line to opencode", expr = true })

		vim.keymap.set("n", "<S-C-u>", function()
			require("opencode").command("session.half.page.up")
		end, { desc = "Scroll opencode up" })
		vim.keymap.set("n", "<S-C-d>", function()
			require("opencode").command("session.half.page.down")
		end, { desc = "Scroll opencode down" })

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
		end, { desc = "Toggle opencode and focus" })
		-- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap)
		-- vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
		-- vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
	end,
}
-- return {
-- 	"NickvanDyke/opencode.nvim",
-- 	dependencies = {
-- 		---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
-- 		{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
-- 	},
-- 	config = function()
-- 		---@type opencode.Opts
--
-- 		vim.o.autoread = true
--
-- 		-- Recommended/example keymaps.
-- 		vim.keymap.set({ "n", "x" }, "<leader>lo", function()
-- 			require("opencode").ask("@this: ", { submit = true })
-- 		end, { desc = "Ask opencode…" })
-- 		vim.keymap.set({ "n", "x" }, "<C-x>", function()
-- 			require("opencode").select()
-- 		end, { desc = "Execute opencode action…" })
--
-- 		-- vim.keymap.set({ "n", "t" }, "<leader>ll", function()
-- 		-- 	require("opencode").toggle()
-- 		-- end, { desc = "Toggle opencode" })
-- 		vim.keymap.set({ "n", "t" }, "<leader>ll", function()
-- 			require("opencode").toggle()
--
-- 			vim.defer_fn(function()
-- 				local provider = require("opencode.config").provider
-- 				if provider and provider.name == "tmux" then
-- 					local pane_id = provider:get_pane_id()
-- 					if pane_id then
-- 						vim.fn.system("tmux select-pane -t " .. pane_id)
-- 					end
-- 				end
-- 			end, 50)
-- 		end, { desc = "Toggle opencode and focus" })
--
-- 		vim.keymap.set({ "n", "x" }, "go", function()
-- 			return require("opencode").operator("@this ")
-- 		end, { desc = "Add range to opencode", expr = true })
--
-- 		vim.keymap.set("v", "<leader>la", function()
-- 			vim.defer_fn(function()
-- 				local provider = require("opencode.config").provider
-- 				if provider and provider.name == "tmux" then
-- 					local pane_id = provider:get_pane_id()
-- 					if pane_id then
-- 						vim.fn.system("tmux select-pane -t " .. pane_id)
-- 					end
-- 				end
-- 			end, 50)
-- 			return require("opencode").operator("@this ") .. "_"
-- 		end, { desc = "Add line to opencode", expr = true })
--
-- 		vim.keymap.set("n", "<S-C-u>", function()
-- 			require("opencode").command("session.half.page.up")
-- 		end, { desc = "Scroll opencode up" })
-- 		vim.keymap.set("n", "<S-C-d>", function()
-- 			require("opencode").command("session.half.page.down")
-- 		end, { desc = "Scroll opencode down" })
--
-- 		-- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
-- 		vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
-- 		vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
-- 	end,
-- }
