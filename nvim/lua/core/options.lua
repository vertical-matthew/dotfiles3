local o = vim.opt
o.number = true
o.relativenumber = true
o.termguicolors = true
o.background = "dark"
o.clipboard = "unnamedplus"
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4
o.textwidth = 0
o.colorcolumn = "80"
o.wrap = false
o.scrolloff = 10
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true
o.inccommand = "split"
o.mouse = "a"
o.signcolumn = "yes"
o.splitright = true
o.splitbelow = true
o.laststatus = 3
o.showmode = false
o.timeoutlen = 400
o.updatetime = 250
o.confirm = true
o.autowrite = true
o.modeline = false
o.undofile = true
o.undolevels = 5000
o.history = 1000
o.backup = true
o.writebackup = true
o.backupcopy = "yes"
o.swapfile = true
o.spelllang = "en_us"
o.foldlevel = 99
o.listchars = { tab = ">·", trail = "~", extends = ">", precedes = "<" }
-- Isolate new plugins, caches and state from the dotfiles2 installation.
local state = vim.fn.stdpath("state") .. "/dotfiles3"
for _, dir in ipairs({ "undo", "backup", "swap" }) do
	vim.fn.mkdir(state .. "/" .. dir, "p", 448)
end
o.undodir = state .. "/undo//"
o.backupdir = state .. "/backup//"
o.directory = state .. "/swap//"
