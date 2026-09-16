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

-- Soft-wrapped prose. wrapping.nvim owns the wrap/textwidth toggle itself (see
-- lua/plugins/wrapping.lua); this only adds the options that make a wrapped
-- line readable, plus motions that move by screen line instead of buffer line.
-- gitcommit is left out on purpose — it is hard wrapped at 72.
-- True when `row` (0-indexed) is a row of a markdown pipe table. The leading-'|'
-- test answers almost every call on its own and costs nothing; treesitter is
-- only consulted to reject a pipe that happens to start a line inside a code
-- block. Falls back to the cheap answer if no markdown parser is available.
local function in_pipe_table(buf, row)
	local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
	if not line or not line:find("^%s*|") then
		return false
	end

	local ok, parser = pcall(vim.treesitter.get_parser, buf, "markdown")
	if not ok or not parser then
		return true
	end

	local trees = parser:parse()
	local tree = trees and trees[1]
	if not tree then
		return true
	end

	local node = tree:root():named_descendant_for_range(row, 0, row, 0)
	while node do
		local kind = node:type()
		if kind == "pipe_table" then
			return true
		elseif kind == "fenced_code_block" or kind == "indented_code_block" then
			return false
		end
		node = node:parent()
	end
	return false
end

local ProseWrap = augroup("ProseWrap", { clear = true })
autocmd("FileType", {
	group = ProseWrap,
	pattern = { "markdown", "text", "rst", "asciidoc", "tex", "latex", "typst", "mail" },
	desc = "Wrap prose at the window edge, preserving indentation.",
	callback = function(ev)
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true -- break between words, not mid-word
		vim.opt_local.breakindent = true -- continuation lines keep the list/quote indent
		-- breakindentopt="" and a two-space showbreak are what render-markdown
		-- requires for `quote.repeat_linebreak` to line up.
		vim.opt_local.breakindentopt = ""
		vim.opt_local.showbreak = "  "

		-- ascii-mermaid diagrams are virtual text: Neovim clips them at the
		-- window edge instead of wrapping, and the renderer has no max width.
		-- Dropping the gutter is the only way to give a wide diagram more room
		-- (worth ~7 columns here). Uncomment if you want that over line numbers.
		-- vim.opt_local.number = false
		-- vim.opt_local.relativenumber = false
		-- vim.opt_local.signcolumn = "no"

		-- j/k step one screen line, unless a count was given (3j stays 3 buffer
		-- lines, so relative line numbers keep working).
		for _, key in ipairs({ "j", "k" }) do
			vim.keymap.set({ "n", "x" }, key, function()
				return vim.v.count == 0 and ("g" .. key) or key
			end, { buffer = ev.buf, expr = true, desc = "Move by display line" })
		end

		-- Tables are the one thing 'wrap' cannot serve. A table row is just a
		-- long line: it folds mid-cell, while the borders around it are overlay
		-- virt-text, which clips instead of folding. The two disagree and the
		-- grid shatters. 'wrap' is a window option with no per-line override, so
		-- the only fix is to drop it while the cursor is actually in a table.
		if vim.bo[ev.buf].filetype ~= "markdown" then
			return
		end

		local function restore_wrap()
			if vim.w.prose_wrap_off then
				vim.w.prose_wrap_off = nil
				vim.wo.wrap = true
			end
		end

		autocmd({ "CursorMoved", "CursorMovedI" }, {
			group = ProseWrap,
			buffer = ev.buf,
			desc = "Drop 'wrap' inside pipe tables so they keep their shape.",
			callback = function(e)
				-- yow (wrapping.nvim) puts the buffer in hard mode on purpose;
				-- wrap is already off there, so leave it alone.
				if vim.b.wrapmode == "hard" then
					return
				end
				if in_pipe_table(e.buf, vim.api.nvim_win_get_cursor(0)[1] - 1) then
					if vim.wo.wrap then
						vim.w.prose_wrap_off = true
						vim.wo.wrap = false
					end
				else
					restore_wrap()
				end
			end,
		})

		-- Leaving the buffer from inside a table would otherwise strand the
		-- window with wrap off, since wrapping.nvim only re-applies soft mode
		-- when a buffer's mode is not already set.
		autocmd("BufLeave", {
			group = ProseWrap,
			buffer = ev.buf,
			desc = "Put 'wrap' back when leaving from inside a table.",
			callback = restore_wrap,
		})
	end,
})
