return {
	"andrewferrier/wrapping.nvim",
	config = function()
		-- Filetypes this plugin is allowed to manage.
		local prose = {
			"asciidoc",
			"gitcommit",
			"latex",
			"mail",
			"markdown",
			"rst",
			"tex",
			"text",
		}

		-- The built-in heuristic compares a file's average line length against
		-- 'textwidth'. When textwidth is 0 (our case) it substitutes 999999, so
		-- the comparison always lands on hard mode, which sets wrap=false and
		-- lets long lines run off the right edge. Setting a filetype's softener
		-- to `true` short-circuits the heuristic and forces soft mode.
		-- gitcommit stays on the plugin's default of `false` (hard wrap at 72).
		local softener = { default = 1.0, gitcommit = false }
		for _, ft in ipairs(prose) do
			if ft ~= "gitcommit" then
				softener[ft] = true
			end
		end

		require("wrapping").setup({
			auto_set_mode_filetype_allowlist = prose,
			softener = softener,
			-- Otherwise every prose buffer announces "Soft wrap mode."
			notify_on_switch = false,
		})
	end,
}
