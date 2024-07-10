return {
	"declancm/cinnamon.nvim",
	config = function()
		require("cinnamon").setup({
			disabled = false, -- Disable the plugin
			keymaps = {
				basic = true, -- Enable the basic keymaps
				extra = false, -- Enable the extra keymaps
			},

			options = {
				mode = "window",
				callback = function() -- Post-movement callback
				end,
				delay = 3, -- Delay between each movement step (in ms)
				max_delta = {
					line = 150, -- Maximum delta for line movements
					column = 200, -- Maximum delta for column movements
				},
			},
		})
	end,
}
