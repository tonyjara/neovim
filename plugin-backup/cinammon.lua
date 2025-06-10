return {
	"declancm/cinnamon.nvim",
	version = "*",
	opts = {
		disabled = false, -- Disable the plugin
		keymaps = {
			basic = true, -- Enable the basic keymaps
			extra = false, -- Enable the extra keymaps
		},

		---@class CinnamonOptions
		options = {
			-- The scrolling mode
			-- `cursor`: animate cursor and window scrolling for any movement
			-- `window`: animate window scrolling ONLY when the cursor moves out of view
			mode = "window",

			-- Only animate scrolling if a count is provided
			count_only = false,

			-- Delay between each movement step (in ms)
			delay = 3,

			max_delta = {
				-- Maximum distance for line movements before scroll
				-- animation is skipped. Set to `false` to disable
				line = 150,
				-- Maximum distance for column movements before scroll
				-- animation is skipped. Set to `false` to disable
				column = 200,
				-- Maximum duration for a movement (in ms). Automatically scales the
				-- delay and step size
				time = 1000,
			},

			step_size = {
				-- Number of cursor/window lines moved per step
				vertical = 1,
				-- Number of cursor/window columns moved per step
				horizontal = 2,
			},

			-- Optional post-movement callback. Not called if the movement is interrupted
			callback = function() end,
		},
		-- options = {
		-- 	mode = "window", -- Window or global
		-- 	callback = function() -- Post-movement callback
		-- 	end,
		-- 	delay = 3, -- Delay between each movement step (in ms)
		-- 	max_delta = {
		-- 		line = 150, -- Maximum delta for line movements
		-- 		column = 200, -- Maximum delta for column movements
		-- 	},
		-- },
	},
}
