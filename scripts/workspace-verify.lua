local notices = {}
local old_notify = vim.notify
vim.notify = function(msg, level, opts)
	if level == vim.log.levels.ERROR then
		table.insert(notices, tostring(msg))
	end
	return old_notify(msg, level, opts)
end
require("lazy").load({
	plugins = {
		"persistence.nvim",
		"snacks.nvim",
		"overseer.nvim",
		"harpoon",
		"trouble.nvim",
		"nvim-treesitter-textobjects",
		"nvim-treesitter-context",
		"aerial.nvim",
		"nvim-dap",
		"neotest",
		"render-markdown.nvim",
		"diffview.nvim",
		"nvim-lspconfig",
	},
})
require("persistence").stop()
local root = vim.fn.tempname() .. " workspace"
vim.fn.mkdir(root .. "/src", "p")
root = vim.uv.fs_realpath(root)
assert(vim.fn.system({ "git", "init", "-q", root }) == "")
vim.fn.writefile({ "[tool.pytest.ini_options]", 'testpaths = ["src"]' }, root .. "/pyproject.toml")
local file = root .. "/src/test_sample.py"
vim.fn.writefile({ "def test_sum():", "    assert 1 + 1 == 2", "", "value = 42", "print(value)" }, file)
vim.cmd.edit(file)
vim.cmd.tcd(root)
assert(require("core.project").root() == root, "Project root mismatch: " .. require('core.project').root() .. ' expected ' .. root .. ' buffer ' .. vim.api.nvim_buf_get_name(0))
local python = require("core.python").executable()
assert(require("core.runner").command(file, "python")[1] == python, "Runner environment mismatch")
assert(require("dap-python").resolve_python() == python, "Debugger environment mismatch")
assert(
	vim.wait(20000, function()
		local clients = vim.lsp.get_clients({ name = "pyright", bufnr = 0 })
		return clients[1] and clients[1].initialized
	end, 50),
	"Pyright failed to initialize"
)
assert(vim.lsp.get_clients({ name = "pyright", bufnr = 0 })[1].config.settings.python.pythonPath == python)
require("neotest").run.run(file)
assert(
	vim.wait(30000, function()
		for _, id in ipairs(require("neotest").state.adapter_ids()) do
			local counts = require("neotest").state.status_counts(id)
			if counts and counts.passed >= 1 then
				return true
			end
		end
	end, 100),
	"Neotest did not report a passing test"
)
local dap = require("dap")
local stopped = false
dap.listeners.after.event_stopped.dotfiles3_verify = function()
	stopped = true
end
vim.api.nvim_win_set_cursor(0, { 4, 0 })
dap.set_breakpoint()
dap.run({
	type = "python",
	request = "launch",
	name = "Verification",
	program = file,
	pythonPath = python,
	cwd = root,
	console = "internalConsole",
})
assert(
	vim.wait(20000, function()
		return stopped
	end, 50),
	"Debugger did not stop at breakpoint"
)
dap.terminate()
vim.wait(500)
require("dapui").close()
local task = require("overseer").new_task(require("overseer.template.user.pytest").builder())
task:start()
assert(
	vim.wait(20000, function()
		return task:is_complete()
	end, 50),
	"Task did not finish"
)
assert(task.status == "SUCCESS", "Task failed: " .. task.status)
vim.cmd("DiffviewOpen")
vim.cmd("DiffviewClose")
vim.cmd("AerialToggle")
vim.cmd("AerialToggle")
require("trouble").open("diagnostics")
require("trouble").close("diagnostics")
local huge = root .. "/huge.json"
vim.fn.writefile({ string.rep(" ", 1100000) }, huge)
vim.cmd.edit(huge)
assert(vim.bo.filetype == "bigfile", "Large-file detection failed")
assert(vim.b.completion == false, "Completion not disabled for big file")
assert(#vim.lsp.get_clients({ bufnr = 0 }) == 0, "LSP attached to big file")
vim.cmd.enew()
vim.bo.filetype = "markdown"
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "# Guide", "", "- [ ] Item" })
require("render-markdown").enable()
vim.api.nvim_exec_autocmds("CursorMoved", { modeline = false })
vim.wait(300)
assert(#notices == 0, table.concat(notices, "\n"))
print(
	"Workspace verified: shared Python, real pytest, debugger breakpoint, named task, review/outline/diagnostics, large-file mode, Markdown"
)
