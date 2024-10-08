return {

	"folke/which-key.nvim",
	config = function()
		local wk = require("which-key")

		local opts = {
			plugins = { spelling = true },
		}
		-- local mappings = {
		-- 	mode = { "n", "v" },
		-- 	["g"] = { name = "+goto" },
		-- 	["gz"] = { name = "+surround" },
		-- 	["]"] = { name = "+next" },
		-- 	["["] = { name = "+prev" },
		-- 	["<leader><tab>"] = { name = "+tabs" },
		-- 	["<leader>b"] = { name = "+buffer" },
		-- 	["<leader>c"] = { name = "+code" },
		-- 	["<leader>f"] = { name = "+file/find" },
		-- 	["<leader>g"] = { name = "+git" },
		-- 	["<leader>gh"] = { name = "+hunks" },
		-- 	["<leader>q"] = { name = "+quit/session" },
		-- 	["<leader>s"] = { name = "+search" },
		-- 	["<leader>u"] = { name = "+ui" },
		-- 	["<leader>w"] = { name = "+windows" },
		-- 	["<leader>x"] = { name = "+diagnostics/quickfix" },
		-- }

		wk.setup(opts)
		-- wk.register(mappings)
	end,
}
