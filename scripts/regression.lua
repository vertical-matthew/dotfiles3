-- Real event and terminal tests; never execute or overwrite a user's source file.
local errors = {}
local notify = vim.notify
vim.notify = function(message, level, opts)
	if level == vim.log.levels.ERROR then
		table.insert(errors, tostring(message))
	end
	return notify(message, level, opts)
end
require("lazy").load({
	plugins = {
		"twilight.nvim",
		"zen-mode.nvim",
		"barbar.nvim",
		"lualine.nvim",
		"which-key.nvim",
		"oil.nvim",
		"blink.cmp",
	},
})
vim.cmd.enew()
vim.bo.filetype = "text"
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "No syntax parser here", "second line" })
require("twilight").enable()
for _, event in ipairs({ "CursorMoved", "WinScrolled", "BufEnter" }) do
	vim.api.nvim_exec_autocmds(event, { modeline = false })
end
vim.wait(150)
require("twilight").disable()
assert(require("twilight.config").options.treesitter == false)
assert(require("lualine").get_config().options.icons_enabled == false)
assert(require("barbar.config").options.icons.filetype.enabled == false)
local runner = require("core.runner")
assert(runner.command("/tmp/file with spaces.py", "python"))
assert(runner.command("/tmp/file.md", "markdown") == nil)
local directory = vim.fn.tempname() .. " runner test"
vim.fn.mkdir(directory, "p")
local file = directory .. "/file with spaces.py"
vim.cmd.enew({ bang = true })
vim.api.nvim_buf_set_name(0, file)
vim.bo.filetype = "python"
vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'print("DOTFILES3_RUN_OK")' })
local mapping = vim.fn.maparg("<leader>r", "n", false, true)
assert(type(mapping.callback) == "function", "Space r missing")
mapping.callback()
local job = vim.b.terminal_job_id
assert(job and job > 0, "Runner did not create terminal")
assert(vim.fn.jobwait({ job }, 10000)[1] == 0, "Python run failed")
vim.wait(100)
assert(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"):find("DOTFILES3_RUN_OK", 1, true))
require("twilight").enable()
vim.api.nvim_exec_autocmds("CursorMoved", { modeline = false })
vim.wait(100)
require("twilight").disable()
assert(#errors == 0, table.concat(errors, "\n"))
vim.notify = notify
vim.fn.delete(file)
vim.fn.delete(directory, "d")
print("dotfiles3: parserless/terminal autocommands, plain symbols, and Space r Python execution passed")
