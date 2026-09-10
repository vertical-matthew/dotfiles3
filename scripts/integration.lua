-- Exercise formatting and real LSP attachment in an unsaved temporary buffer.
local conform = require("conform")
require("lazy").load({ plugins = { "nvim-lspconfig" } })
vim.cmd.enew()
vim.api.nvim_buf_set_name(0, vim.fn.tempname() .. ".py")
vim.bo.filetype = "python"
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "x=  1", "print(x)" })
local format_error
conform.format({ async = false, timeout_ms = 10000 }, function(err)
	format_error = err
end)
assert(not format_error, tostring(format_error))
assert(vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == "x = 1", "Python formatting failed")
assert(
	vim.wait(15000, function()
		local names = {}
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
			names[client.name] = client.initialized
		end
		return names.pyright and names.ruff
	end, 100),
	"Pyright/Ruff did not initialize"
)
assert(vim.fn.maparg("K", "n") == "{", "LSP replaced paragraph mapping")
assert(vim.fn.maparg("<leader>lk", "n", false, true).callback, "LSP hover mapping missing")
require("blink.cmp").get_lsp_capabilities()
assert(require("telescope").extensions.fzf, "Native fzf extension missing")
vim.cmd.enew({ bang = true })
vim.bo.filetype = "org"
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "* TODO Integration check" })
assert(pcall(vim.treesitter.start, 0, "org"), "Org parser unavailable")
local org_mappings = require("orgmode.org.mappings")
for _, method in ipairs({ "todo_next_state", "org_time_stamp", "org_deadline", "org_schedule" }) do
	assert(type(org_mappings[method]) == "function", "Org action unavailable: " .. method)
end
print("dotfiles3: Python formatting, Pyright/Ruff attachment, LSP mappings, fzf, and Org verified")
vim.bo.modified = false
