local M = {}

function M.command(file, filetype)
	local commands = {
		python = { "python3" },
		javascript = { "node" },
		lua = { "nvim", "--clean", "-l" },
		sh = { "sh" },
		bash = { "bash" },
		zsh = { "zsh" },
		ruby = { "ruby" },
		perl = { "perl" },
		swift = { "swift" },
	}
	local command = commands[filetype]
	if not command then
		return nil, "No runner configured for " .. (filetype ~= "" and filetype or "this filetype")
	end
	if filetype == "python" then
		command = { require("core.python").executable(file) }
	end
	if vim.fn.executable(command[1]) ~= 1 then
		return nil, "Runner is not installed: " .. command[1]
	end
	return vim.list_extend(vim.deepcopy(command), { file })
end

function M.run()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" or vim.bo.buftype ~= "" then
		vim.notify("Save a source file before running it", vim.log.levels.WARN)
		return
	end
	local command, err = M.command(file, vim.bo.filetype)
	if not command then
		vim.notify(err, vim.log.levels.WARN)
		return
	end
	local saved, save_error = pcall(vim.cmd.write)
	if not saved then
		vim.notify(tostring(save_error), vim.log.levels.ERROR)
		return
	end
	vim.cmd("botright 12new")
	local job = vim.fn.jobstart(command, { term = true, cwd = require("core.project").root(vim.fn.bufnr(file)) })
	if job <= 0 then
		vim.notify("Unable to start file runner", vim.log.levels.ERROR)
		return
	end
	vim.cmd.startinsert()
	return job
end

return M
