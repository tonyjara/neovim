require("settings.keymaps")
require("settings.options")
require("settings.autocmds")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- make sure to set `mapleader` before lazy so your mappings are correct
local opts = {
	change_detection = { enabled = false },
}

if vim.g.vscode then
	-- VSCode extension
	--
	require("lazy").setup({
		--   { import = "plugins.cursor" },
		--  { import = "plugins.editor" },
	}, opts)
else
	-- ordinary Neovim
	--
	require("lazy").setup({
		{ import = "plugins" },
		{ import = "plugins.lsp" },
	}, opts)
end
