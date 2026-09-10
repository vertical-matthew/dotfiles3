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
	root = root .. "/lazy",
	lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
	defaults = { lazy = true },
	checker = { enabled = false },
	change_detection = { notify = false },
})
