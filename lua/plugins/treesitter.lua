-- nvim-treesitter `main` branch (the 0.12-compatible rewrite).
--
-- `main` is a different plugin from `master`: there is no `configs.setup()`,
-- no modules, and no `ensure_installed`. It only installs parsers + queries;
-- highlighting, folding and indentation are enabled per buffer by us below.
-- Parsers and queries land in `stdpath('data')/site`, NOT in the plugin dir.

local ENSURE_INSTALLED = {
	"astro",
	"bash",
	"c",
	"css",
	"graphql",
	"html",
	"http",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"make",
	"markdown",
	"markdown_inline",
	"prisma",
	"python",
	"svelte",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
}

-- Replaces the old `ignore_install` — never auto-install these.
local IGNORE_INSTALL = { haskell = true }

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		-- `main` does not support lazy-loading, and the parser install dir is
		-- prepended to 'runtimepath' at load time.
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			-- Parser compilation shells out to `tree-sitter build` -> `cc`.
			-- The active Xcode (26.4) ships an `ld` that cannot read the
			-- MacOSX27 SDK's .tbd files that Command Line Tools 27 installed
			-- ("unknown architecture arm64e.x1"), so every link fails. Pin the
			-- last SDK that Xcode's linker understands. Remove this once Xcode
			-- is updated to 27.x -- switching xcode-select to CLT would fix it
			-- too, but that breaks Flutter/iOS builds.
			if vim.fn.has("mac") == 1 and not vim.env.SDKROOT then
				local sdk = "/Library/Developer/CommandLineTools/SDKs/MacOSX26.5.sdk"
				if vim.uv.fs_stat(sdk) then
					vim.env.SDKROOT = sdk
				end
			end

			ts.setup()

			-- Filetypes whose parser is named differently.
			vim.treesitter.language.register("bash", "sh")
			-- Neovim has no .mdx detection at all, so without this the mdx
			-- registration below never fires and .mdx files fall back to
			-- content-based detection (usually `conf`).
			vim.filetype.add({ extension = { mdx = "mdx" } })
			vim.treesitter.language.register("markdown", "mdx")

			-- <C-space> / <bs>, previously the `incremental_selection` module.
			require("settings.ts-incremental-selection").setup()

			local installed = {}
			for _, lang in ipairs(ts.get_installed("parsers")) do
				installed[lang] = true
			end

			local missing = vim.tbl_filter(function(lang)
				return not installed[lang]
			end, ENSURE_INSTALLED)
			if #missing > 0 then
				ts.install(missing, { summary = true })
			end

			-- `main` dropped `auto_install`, so do it by hand: on the first
			-- visit to a filetype whose parser is available but not installed,
			-- fetch it and turn features on once it lands.
			local available = {}
			for _, lang in ipairs(ts.get_available()) do
				available[lang] = true
			end

			local function enable(buf)
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end
				-- Highlighting, provided by Neovim. Regex syntax is left on,
				-- matching the old `additional_vim_regex_highlighting = true`.
				if not pcall(vim.treesitter.start, buf) then
					return
				end
				-- Indentation, provided by nvim-treesitter (experimental).
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				-- Folds, provided by Neovim. These are window-local-per-buffer,
				-- so set them on every window actually showing this buffer --
				-- the auto-install path below runs long after the FileType
				-- event, when `buf` may no longer be the current buffer.
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					if vim.api.nvim_win_get_buf(win) == buf then
						vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
						vim.wo[win][0].foldmethod = "expr"
					end
				end
			end

			local pending = {}

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter_enable", { clear = true }),
				callback = function(args)
					local buf = args.buf
					local lang = vim.treesitter.language.get_lang(args.match)
					if not lang or IGNORE_INSTALL[lang] then
						return
					end

					if installed[lang] then
						enable(buf)
						return
					end

					if not available[lang] or pending[lang] then
						return
					end

					pending[lang] = true
					ts.install(lang):await(function(err)
						pending[lang] = nil
						if err then
							return
						end
						installed[lang] = true
						vim.schedule(function()
							enable(buf)
						end)
					end)
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		lazy = false,
	},
}
