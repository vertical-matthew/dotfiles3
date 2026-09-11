local root = vim.fn.stdpath("data") .. "/dotfiles3"
local path = root .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(path) then
	local result = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		path,
	})
	if vim.v.shell_error ~= 0 then
		error("lazy.nvim bootstrap failed: " .. result)
	end
end
vim.opt.rtp:prepend(path)
require("lazy").setup({ { import = "plugins" } }, {
	rocks = { enabled = false },
	ui = {
		icons = {
			cmd = ":",
			config = "cfg",
			event = "event",
			ft = "ft",
			init = "init",
			import = "import",
			keys = "key",
			lazy = "lazy",
			loaded = "+",
			not_loaded = "-",
			plugin = "plugin",
			runtime = "runtime",
			source = "source",
			start = "start",
			task = "task",
			list = { "-", ">", "*" },
		},
	},
	root = root .. "/lazy",
	lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
	defaults = { lazy = true },
	checker = { enabled = false },
	change_detection = { notify = false },
})
