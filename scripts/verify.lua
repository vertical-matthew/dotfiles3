-- Loads actual configuration/plugins in a headless process; no user files modified.
assert(vim.v.errmsg == "", "Startup error: " .. vim.v.errmsg)
require("lazy").load({
	plugins = {
		"blink.cmp",
		"nvim-lspconfig",
		"conform.nvim",
		"oil.nvim",
		"telescope.nvim",
		"hop.nvim",
		"barbar.nvim",
		"yanky.nvim",
		"mini.move",
		"orgmode",
		"grug-far.nvim",
	},
})
local failures = {}
local function check(ok, message)
	if not ok then
		table.insert(failures, message)
	end
end
check(vim.fn.has("nvim-0.12") == 1, "Neovim 0.12+ required")
for _, command in ipairs({ "Oil", "Telescope", "HopWord", "BufferNext", "GrugFar" }) do
	check(vim.fn.exists(":" .. command) == 2, "Missing command: " .. command)
end
for key, rhs in pairs({ J = "}", K = "{", H = "<C-O>", L = "<C-I>", ["<Up>"] = "gg", ["<Down>"] = "G" }) do
	local actual = vim.api.nvim_replace_termcodes(vim.fn.maparg(key, "n"), true, true, true)
	check(actual == vim.api.nvim_replace_termcodes(rhs, true, true, true), "Mapping changed: " .. key)
end
for _, parser in ipairs({ "lua", "python", "markdown", "swift" }) do
	check(pcall(vim.treesitter.language.add, parser), "Missing parser: " .. parser)
end
for _, binary in ipairs({ "rg", "fd", "pyright-langserver", "ruff", "stylua", "lua-language-server", "prettier" }) do
	check(vim.fn.executable(binary) == 1, "Missing tool: " .. binary)
end
check(require("conform").get_formatter_info("ruff_format").available, "Ruff formatter unavailable")
check(require("conform").get_formatter_info("stylua").available, "StyLua formatter unavailable")
if #failures > 0 then
	error(table.concat(failures, "\n"))
end
print("dotfiles3: plugin commands, mappings, parsers, and tools verified")
