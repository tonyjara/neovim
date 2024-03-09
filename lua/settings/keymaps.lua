vim.g.mapleader = " " -- maps space to word leader, this needs to be here regardless of it being in the init.lua

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Navigate start, end, top and bottom
map("n", "L", "$", opts) --end
map("n", "H", "^", opts) --start

map("v", "L", "$", opts) --end
map("v", "H", "^", opts) --start

-- Unmap q so that no macros get accidentally triggered
map("n", "q", "<Nop>", opts)
map("v", "q", "<Nop>", opts)

-- INSERT MODE REBINDS
-- Exits i mode
map("i", "jj", "<Esc>")
map("i", "jk", "<Esc>")
map("i", "<C-s>", "<Esc><cmd>update<CR>") -- SAVES file

--NORMAL MODE REBINDS
-- Pane navigation
map("n", "d", '"_d') -- delete without cutting
map("n", "c", '"_c') -- change without cutting
map("n", "<C-s>", "<cmd>update<CR>") -- SAVES file

--VISUAL MODE REBINDS
map("v", "d", '"_d') -- delete without cutting
map("v", "c", '"_c') -- delete without cutting
map("v", "<C-s>", "<Esc><cmd>update<CR>") -- SAVES file

-- PASTE REBINDS
map("n", "]p", "o<Esc>p") -- Paste on the next line

-- NOTE: Sort
map("v", "<leader>ss", ":'<,'>sort<CR>", opts)
map("v", "<leader>sr", ":'<,'>sort!<CR>", { noremap = true, silent = true, desc = "Sort reverse" })
map("v", "<leader>su", ":'<,'>sort u<CR>", { noremap = true, silent = true, desc = "Sort unique" })
map("n", "<leader>si{", "vi{:'<,'>sort<CR>", { noremap = true, silent = true, desc = "Sort inside brackets" })

-- Spell check zg add word to dictionary, zw remove word from dictionary or makes it incorrect
map(
	"n",
	"<leader>sce",
	"<cmd>:set spell spelllang=en_us<CR>",
	{ noremap = true, silent = true, desc = "Spell check enable" }
)
map("n", "<leader>scd", "<cmd>:set nospell<CR>", { noremap = true, silent = true, desc = "Spell check disable" })

-- Go to next copy of word under cursor
map("n", "<C-n>", "*", { noremap = true, silent = true, desc = "Go to next copy of word under cursor" })
