return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local function my_on_attach(bufnr)
			local api = require("nvim-tree.api")

			-- Open files when creating
			api.events.subscribe(api.events.Event.FileCreated, function(file)
				vim.cmd("edit " .. file.fname)
			end)
			-- default mappings
			api.config.mappings.default_on_attach(bufnr)

			local function edit_or_open()
				local node = api.tree.get_node_under_cursor()

				if node.nodes ~= nil then
					-- expand or collapse folder
					api.node.open.edit()
				else
					-- open file
					api.node.open.edit()
					-- Close the tree if file was opened
					api.tree.close()
				end
			end

			-- open as vsplit on current node
			local function vsplit_preview()
				local node = api.tree.get_node_under_cursor()

				if node.nodes ~= nil then
					-- expand or collapse folder
					api.node.open.edit()
				else
					-- open file as vsplit
					api.node.open.vertical()
				end

				-- Finally refocus on tree if it was lost
				api.tree.focus()
			end

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end
			--[[ vim.api.nvim_set_keymap("n", "<C-h>", ":NvimTreeToggle<cr>", { silent = true, noremap = true }) ]]

			-- on_attach
			vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
			vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
			vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
			vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
			vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
			vim.keymap.set("n", "<esc>", api.tree.close, opts("Close"))
		end

		local HEIGHT_RATIO = 0.8 -- You can change this
		local WIDTH_RATIO = 0.5 -- You can change this too

		local floatView = {
			float = {
				enable = true,
				open_win_config = function()
					local screen_w = vim.opt.columns:get()
					local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
					local window_w = screen_w * WIDTH_RATIO
					local window_h = screen_h * HEIGHT_RATIO
					local window_w_int = math.floor(window_w)
					local window_h_int = math.floor(window_h)
					local center_x = (screen_w - window_w) / 2
					local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
					return {
						border = "rounded",
						relative = "editor",
						row = center_y,
						col = center_x,
						width = window_w_int,
						height = window_h_int,
					}
				end,
			},
			width = function()
				return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
			end,
		}

		local setup = {
			--rooter
			sync_root_with_cwd = true,
			respect_buf_cwd = true,
			sort_by = "case_sensitive",
			renderer = {
				group_empty = true,
			},
			--rooter
			on_attach = my_on_attach,
			diagnostics = {
				enable = true,
				icons = {
					hint = "",
					info = "",
					warning = "",
					error = "",
				},
			},
			update_focused_file = {
				enable = true,
				update_cwd = true,
				update_root = true,
				ignore_list = {},
			},
			filters = {
				dotfiles = false,
				custom = {},
			},
			git = {
				enable = true,
				ignore = false,
				timeout = 500,
			},
		}

		local nvimtree = require("nvim-tree")
		setup.view = floatView
		nvimtree.setup(setup)

		local opts = { noremap = true, silent = true }
		vim.keymap.set("n", "<leader>bb", "<cmd>NvimTreeToggle<CR>", opts)
		vim.keymap.set("n", "<leader>br", function()
			setup.view = floatView
			nvimtree.setup(setup)
			vim.cmd("NvimTreeToggle")
		end, { noremap = true, silent = true, desc = "File tree position reset" })
		vim.keymap.set("n", "<leader>bf", "<cmd>NvimTreeFindFile<CR>", opts)
		vim.keymap.set("n", "<leader>bl", function()
			-- vim.cmd("vnew | wincmd H | 40 wincmd |")
			-- require("nvim-tree.api").tree.open({ winid = vim.api.nvim_get_current_win() })
			setup.view = {
				width = 50,
			}
			nvimtree.setup(setup)
			vim.cmd("NvimTreeToggle")
		end, { noremap = true, silent = true, desc = "Open tree left" })
		vim.keymap.set("n", "<leader>cc", "<cmd>NvimTreeCollapse<CR>", opts)
	end,
}
