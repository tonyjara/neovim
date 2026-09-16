return {
	"MeanderingProgrammer/markdown.nvim",
	main = "render-markdown",
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
	opts = {
		code = {
			-- Turn on / off code block & inline code rendering
			enabled = true,
			-- Turn on / off any sign column related rendering
			sign = true,
			-- Determines how code blocks & inline code are rendered:
			--  none: disables all rendering
			--  normal: adds highlight group to code blocks & inline code, adds padding to code blocks
			--  language: adds language icon to sign column if enabled and icon + name above code blocks
			--  full: normal + language
			style = "language",
			-- Amount of padding to add to the left of code blocks
			left_pad = 0,
			-- Amount of padding to add to the right of code blocks when width is 'block'
			right_pad = 0,
			-- Width of the code block background:
			--  block: width of the code block
			--  full: full width of the window
			-- 'full' keeps the background behind wrapped code lines too.
			width = "full",
			-- Determins how the top / bottom of code block are rendered:
			--  thick: use the same highlight as the code body
			--  thin: when lines are empty overlay the above & below icons
			border = "thin",
			-- Used above code blocks for thin border
			above = "▄",
			-- Used below code blocks for thin border
			below = "▀",
			-- Highlight for code blocks & inline code
			-- highlight = "RenderMarkdownCode",
			-- highlight_inline = "RenderMarkdownCodeInline",
		},
		quote = {
			-- Now that prose soft wraps, repeat the quote bar down every wrapped
			-- line so a long quote still reads as one block.
			repeat_linebreak = true,
		},
		pipe_table = {
			-- 'padded' pads every cell out to the widest value in its column,
			-- which pushes wide tables past the window edge. 'trimmed' drops
			-- that extra whitespace so tables stay inside the window longer.
			cell = "trimmed",
		},
	},
}
