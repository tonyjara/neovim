-- Replacement for nvim-treesitter master's `incremental_selection` module,
-- which the `main` branch rewrite dropped. Keeps <C-space> / <bs> working:
-- <C-space> selects the node under the cursor, then grows to the enclosing
-- node on each repeat; <bs> shrinks back down the same path.

local M = {}

---@type table<integer, TSNode[]>
local stack = {}

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
	group = vim.api.nvim_create_augroup("ts_incremental_selection", { clear = true }),
	callback = function(args)
		stack[args.buf] = nil
	end,
})

---@param node TSNode
local function select(node)
	local srow, scol, erow, ecol = node:range()
	if ecol == 0 then
		-- Node ends at the start of a line; pull the end back onto the
		-- previous line so the selection does not swallow a blank row.
		erow = erow - 1
		ecol = #vim.api.nvim_buf_get_lines(0, erow, erow + 1, false)[1]
	end
	if vim.fn.mode() ~= "v" then
		vim.cmd("normal! v")
	end
	vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
	vim.cmd("normal! o")
	vim.api.nvim_win_set_cursor(0, { erow + 1, math.max(ecol - 1, 0) })
end

---@param a TSNode
---@param b TSNode
local function same_range(a, b)
	local a1, a2, a3, a4 = a:range()
	local b1, b2, b3, b4 = b:range()
	return a1 == b1 and a2 == b2 and a3 == b3 and a4 == b4
end

---Does the current visual selection still match the node we last selected?
---@param node TSNode
local function in_sync(node)
	if vim.fn.mode() ~= "v" then
		return false
	end
	local srow, scol, erow, ecol = node:range()
	local s, e = vim.fn.getpos("v"), vim.fn.getpos(".")
	if s[2] > e[2] or (s[2] == e[2] and s[3] > e[3]) then
		s, e = e, s
	end
	if ecol == 0 then
		erow, ecol = erow - 1, math.huge
	end
	return s[2] - 1 == srow and s[3] - 1 == scol and e[2] - 1 == erow and e[3] <= ecol
end

function M.init()
	local node = vim.treesitter.get_node({ ignore_injections = false })
	if not node then
		return
	end
	stack[vim.api.nvim_get_current_buf()] = { node }
	select(node)
end

function M.increment()
	local buf = vim.api.nvim_get_current_buf()
	local nodes = stack[buf]
	if not nodes or #nodes == 0 or not in_sync(nodes[#nodes]) then
		return M.init()
	end

	local node = nodes[#nodes]
	local parent = node:parent()
	-- Skip ancestors that cover exactly the same text, otherwise a press
	-- would appear to do nothing.
	while parent and same_range(parent, node) do
		parent = parent:parent()
	end
	if not parent then
		return
	end

	nodes[#nodes + 1] = parent
	select(parent)
end

function M.decrement()
	local buf = vim.api.nvim_get_current_buf()
	local nodes = stack[buf]
	if not nodes or #nodes < 2 then
		return
	end
	nodes[#nodes] = nil
	select(nodes[#nodes])
end

function M.setup()
	vim.keymap.set("n", "<C-space>", M.init, { desc = "Init treesitter selection" })
	vim.keymap.set("x", "<C-space>", M.increment, { desc = "Grow treesitter selection" })
	vim.keymap.set("x", "<bs>", M.decrement, { desc = "Shrink treesitter selection" })
end

return M
