vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
-- Prevents swap file warning from showing up
vim.opt.swapfile = false

-- Avoid loosing undo history after exiting
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.rnu = true
vim.opt.nu = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.splitright = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.o.termguicolors = true
vim.opt.cursorline = true
vim.opt.number = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.spelllang = "en_us,es"

-- clipboard
vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- search settings
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive

-- Get rid of ~ on the side
vim.opt.fillchars = { eob = " " }

vim.opt.fo:remove("c")     -- Dont comment new lines after commented line
vim.opt.fo:remove("r")     -- Dont comment new lines after commented line
vim.opt.fo:remove({ "o" }) -- Dont comment new lines after commented line

vim.opt.cmdheight = 0      -- removes pesky bottom line
