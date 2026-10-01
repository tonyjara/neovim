return {
	"echasnovski/mini.move",
	version = false,
	config = function()
		local MiniMove = require("mini.move")

		MiniMove.setup({
			mappings = {
				-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
				-- left/right stay off: <M-h>/<M-l> cycle buffers (see bufferline.lua).
				-- Commenting them out is not enough — setup() merges with the
				-- defaults, so they have to be blanked explicitly.
				left = "",
				right = "",
				down = "<M-j>",
				up = "<M-k>",

				-- Move current line in Normal mode
				line_left = "",
				line_right = "",
				line_down = "<M-j>",
				line_up = "<M-k>",
			},
		})

		-- Option-key aliases. Without `macos-option-as-alt`, macOS composes
		-- Option+j/k into ∆/˚ rather than sending Alt, so nvim never sees
		-- <M-j>/<M-k>. Bind the glyphs to the same actions so the keys work on
		-- either terminal setting.
		for glyph, dir in pairs({ ["∆"] = "down", ["˚"] = "up" }) do
			vim.keymap.set("n", glyph, function()
				MiniMove.move_line(dir)
			end, { silent = true, desc = "Move line " .. dir })

			vim.keymap.set("x", glyph, function()
				MiniMove.move_selection(dir)
			end, { silent = true, desc = "Move selection " .. dir })
		end
	end,
}
