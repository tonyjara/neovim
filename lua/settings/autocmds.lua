local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local restart_odoo_ls_on_resume = false

-- Remove comments after pressing enter
local FormatOptions = augroup("FormatOptions", { clear = true })
autocmd("BufEnter", {
	group = FormatOptions,
	pattern = "*",
	desc = "Set buffer local formatoptions.",
	callback = function()
		vim.opt_local.formatoptions:remove({
			"r", -- Automatically insert the current comment leader after hitting <Enter> in Insert mode.
			"o", -- Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
		})
	end,
})

-- Make sure to set the filetype for .env files
autocmd({ "BufEnter", "BufNewFile" }, {
	pattern = ".env*",
	command = "set filetype=conf",
})

local LspLifecycle = augroup("LspLifecycle", { clear = true })

autocmd("VimSuspend", {
	group = LspLifecycle,
	desc = "Stop odoo_ls before suspending Neovim.",
	callback = function()
		local clients = vim.lsp.get_clients({ name = "odoo_ls" })
		restart_odoo_ls_on_resume = #clients > 0
		if restart_odoo_ls_on_resume then
			vim.lsp.stop_client(clients, true)
		end
	end,
})

autocmd("VimResume", {
	group = LspLifecycle,
	desc = "Restart odoo_ls after resuming Neovim.",
	callback = function()
		if not restart_odoo_ls_on_resume then
			return
		end

		restart_odoo_ls_on_resume = false
		vim.schedule(function()
			vim.lsp.enable("odoo_ls", true)
		end)
	end,
})

-- Persistent Folds
-- local save_fold = augroup("Persistent Folds", { clear = true })
-- autocmd("BufWinLeave", {
-- 	pattern = "*.*",
-- 	callback = function()
-- 		vim.cmd.mkview()
-- 	end,
-- 	group = save_fold,
-- })
-- autocmd("BufWinEnter", {
-- 	pattern = "*.*",
-- 	callback = function()
-- 		vim.cmd.loadview({ mods = { emsg_silent = true } })
-- 	end,
-- 	group = save_fold,
-- })
--
