return {
	"folke/flash.nvim",
	event = "VeryLazy",
	--@type Flash.Config
	opts = {},
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				-- default options: exact mode, multi window, all directions, with a backdrop
				require("flash").jump({
					-- search = {
					-- 	mode = function(str)
					-- 		return "\\<" .. str
					-- 	end,
					-- },
					-- continue = false,
				})
			end,
			desc = "Flash",
		},
		-- { "f", mode = { "n", "x", "o" }, false }, doesn't work
		-- { "F", mode = { "n", "x", "o" }, false }, doesn't work
		{
			"S",
			mode = { "n", "o", "x" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter",
		},
		{
			"r",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Remote Flash",
		},
	},
}
