local M = { selected = {} }
function M.executable(file)
	file = file or vim.api.nvim_buf_get_name(0)
	local root = vim.fs.root(file, { ".git" }) or vim.fs.root(file, { "pyproject.toml" }) or vim.fs.dirname(file)
	if M.selected[root] and vim.fn.executable(M.selected[root]) == 1 then
		return M.selected[root]
	end
	local candidates = {}
	if vim.env.VIRTUAL_ENV then
		table.insert(candidates, vim.env.VIRTUAL_ENV .. "/bin/python")
	end
	local dir = vim.fs.dirname(file)
	while dir do
		for _, name in ipairs({ ".venv", "venv" }) do
			table.insert(candidates, dir .. "/" .. name .. "/bin/python")
		end
		local parent = vim.fs.dirname(dir)
		if parent == dir then
			break
		end
		dir = parent
	end
	table.insert(candidates, vim.fn.stdpath("data") .. "/dotfiles3/python/bin/python")
	table.insert(candidates, vim.fn.exepath("python3"))
	for _, candidate in ipairs(candidates) do
		if vim.fn.executable(candidate) == 1 then
			return candidate
		end
	end
	return "python3"
end
function M.select(path)
	path = vim.fn.expand(path)
	if vim.fn.isdirectory(path) == 1 then
		path = path .. "/bin/python"
	end
	if vim.fn.executable(path) ~= 1 then
		vim.notify("Not an executable Python: " .. path, vim.log.levels.ERROR)
		return false
	end
	local root = require("core.project").root()
	M.selected[root] = path
	for _, client in ipairs(vim.lsp.get_clients({ name = "pyright" })) do
		if client.config.root_dir == root then
			client.config.settings =
				vim.tbl_deep_extend("force", client.config.settings or {}, { python = { pythonPath = path } })
			client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		end
	end
	vim.notify("Python for " .. root .. ": " .. path)
	return true
end
function M.pick()
	local root = require("core.project").root()
	local options = { M.executable(), root .. "/.venv", root .. "/venv", "Enter another interpreter..." }
	vim.ui.select(options, { prompt = "Python environment (runner, tests, debugger and Pyright)" }, function(choice)
		if choice == options[#options] then
			vim.ui.input(
				{ prompt = "Environment directory or Python executable: ", completion = "file" },
				function(path)
					if path and path ~= "" then
						M.select(path)
					end
				end
			)
		elseif choice then
			M.select(choice)
		end
	end)
end
return M
