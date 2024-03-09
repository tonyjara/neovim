return {
	"NvChad/nvim-colorizer.lua",
	event = "BufRead",
	opts = {
		user_default_options = {
			mode = "background",
			names = true,
			tailwind = true,
		},
		filetypes = {
			"*",
			css = { names = true, css = true, css_fn = true },
		},
	},
}
