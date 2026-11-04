local M = {}
function M.root(buf)
	local name = vim.api.nvim_buf_get_name(buf or 0)
	local path = name ~= "" and name or vim.fn.getcwd()
	return vim.fs.root(path, { ".git" })
		or vim.fs.root(path, { "pyproject.toml", "package.json", "composer.json", "Makefile" })
		or (name ~= "" and vim.fs.dirname(name) or vim.fn.getcwd())
end
function M.directory()
	return vim.fs.dirname(vim.api.nvim_buf_get_name(0)) or vim.fn.getcwd()
end
return M
