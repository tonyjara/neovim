return {
	"echasnovski/mini.move",
	version = false,
	config = function()
		require("mini.move").setup({
			mappings = {
				-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
				-- left = '<M-h>',
				-- right = '<M-l>',
				down = "∆",
				up = "˚",

				-- Move current line in Normal mode
				-- line_left = '<M-h>',
				-- line_right = '<M-l>',
				line_down = "∆",
				line_up = "˚",
			},
		})
	end,
}
