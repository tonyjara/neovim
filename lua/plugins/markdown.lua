return {
	"MeanderingProgrammer/markdown.nvim",
	main = "render-markdown",
	opts = {},
	-- name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
	config = function()
		require("render-markdown").setup({
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
		})
	end,
}
