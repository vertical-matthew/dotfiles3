local function map(mode, lhs, rhs, desc, extra)
	vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { silent = true, desc = desc }, extra or {}))
end
local function pick(name)
	return function()
		require("telescope.builtin")[name]()
	end
end
local function org(action)
	return function()
		require("orgmode").action(action)
	end
end
map({ "n", "x" }, ";", ":", "Command line", { silent = false })
map("i", "jk", "<Esc>", "Leave insert mode")
map("n", "q", "<cmd>quit<cr>", "Close window")
map("n", "qq", "<cmd>qall<cr>", "Quit all")
map("n", "ww", "<cmd>wall<cr>", "Write all")
map("n", "<leader>qq", "<cmd>confirm qall<cr>", "Quit all with unsaved-change prompt")
map("n", "<leader>Q", "q", "Record macro")
map({ "n", "i", "x" }, "<C-s>", "<Esc><cmd>update<cr>", "Save current file")
map("n", "<leader><leader>h", "<cmd>vsplit<cr>", "Split side by side")
map("n", "<leader><leader>v", "<cmd>split<cr>", "Split above/below")
for _, key in ipairs({ "h", "j", "k", "l" }) do
	map("n", "<leader>" .. key, "<C-w>" .. key, "Focus window " .. key)
	map("n", "<A-" .. key .. ">", "<C-w>" .. key, "Focus window " .. key)
end
for key, command in pairs({
	Left = "vertical resize +2",
	Right = "vertical resize -2",
	Up = "resize +2",
	Down = "resize -2",
}) do
	map("n", "<A-S-" .. key .. ">", "<cmd>" .. command .. "<cr>", "Resize window")
end
map("x", "<", "<gv", "Indent left and retain selection")
map("x", ">", ">gv", "Indent right and retain selection")
map("n", "<leader><Left>", "<<", "Indent left")
map("n", "<leader><Right>", ">>", "Indent right")
map("n", "<leader><Up>", function()
	require("mini.move").move_line("up")
end, "Move line up")
map("n", "<leader><Down>", function()
	require("mini.move").move_line("down")
end, "Move line down")
map({ "n", "x" }, "J", "}", "Next paragraph")
map({ "n", "x" }, "K", "{", "Previous paragraph")
map("n", "H", "<C-o>", "Older jump")
map("n", "L", "<C-i>", "Newer jump")
map("n", "<C-j>", "<C-d>", "Half page down")
map("n", "<C-k>", "<C-u>", "Half page up")
map("n", "<C-h>", "^", "First nonblank")
map("n", "<C-l>", "$", "End of line")
map("n", "<Left>", "<cmd>BufferPrevious<cr>", "Previous buffer")
map("n", "<Right>", "<cmd>BufferNext<cr>", "Next buffer")
map("n", "<Up>", "gg", "First line")
map("n", "<Down>", "G", "Last line")
map("n", "<BS>", "u", "Undo")
map("n", "<S-BS>", "<C-r>", "Redo (terminal dependent)")
map("n", "Y", "y$", "Yank to end of line")
map("n", "<CR>", "<cmd>nohlsearch<cr><cr>", "Clear search and next line")
map("n", "<leader>x", "<cmd>buffer #<cr>", "Alternate buffer")
map("n", "<leader>vi", function()
	vim.cmd.tabedit(vim.fn.stdpath("config") .. "/init.lua")
end, "Edit configuration")
map("n", "<leader>help", function()
	local config = vim.uv.fs_realpath(vim.fn.stdpath("config"))
	vim.cmd.edit(vim.fs.dirname(config) .. "/README.md")
end, "Open dotfiles3 guide")
map("n", "<leader><leader>t", "<cmd>terminal<cr>", "Open terminal")
map("t", "<Esc><Esc>", "<C-\\><C-n>", "Leave terminal mode")
map("n", "<leader><leader>c", "zM", "Close all folds")
map("n", "<leader><leader>o", "zR", "Open all folds")
map("n", "<leader><leader>f", "za", "Toggle fold")
map("n", "<leader>-", "<cmd>g/^$/delete _<cr>", "Delete empty lines")
for key, picker in pairs({
	["ff"] = "find_files",
	fg = "live_grep",
	fb = "buffers",
	fh = "help_tags",
	fl = "current_buffer_fuzzy_find",
	["//"] = "current_buffer_fuzzy_find",
}) do
	map("n", "<leader>" .. key, pick(picker), (picker:gsub("_", " ")))
end
map("n", "//", pick("current_buffer_fuzzy_find"), "Search buffer")
map("n", "?", pick("live_grep"), "Search project")
for _, key in ipairs({ "-", "<F5>", "<leader>5" }) do
	map("n", key, "<cmd>Oil<cr>", "Browse directory")
end
for _, key in ipairs({ "<F6>", "<leader>6" }) do
	map("n", key, "<cmd>UndotreeToggle<cr>", "Undo tree")
end
for _, key in ipairs({ "<F8>", "<leader>8" }) do
	map("n", key, pick("lsp_document_symbols"), "Document symbols (requires LSP)")
end
map("n", "<leader>7", function()
	require("telescope").extensions.yank_history.yank_history()
end, "Yank history")
for key, command in pairs({
	a = "HopLine",
	w = "HopWord",
	pat = "HopPattern",
	["<leader>/"] = "HopPattern",
	["1"] = "ZenMode",
	["2"] = "Twilight",
	["<leader>g"] = "ZenMode",
	["<leader>l"] = "Twilight",
}) do
	map("n", "<leader>" .. key, "<cmd>" .. command .. "<cr>", command)
end
map("n", "<leader>'", "ysiw'", "Quote word (single)", { remap = true })
map("n", '<leader>"', 'ysiw"', "Quote word (double)", { remap = true })
map("n", "<A-c>", "gcc", "Toggle comment", { remap = true })
map("x", "<A-c>", "gc", "Toggle comments", { remap = true })
map("n", "[g", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, "Previous diagnostic")
map("n", "]g", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, "Next diagnostic")
map("n", "<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
for _, key in ipairs({ "<leader>0", "<leader>fi" }) do
	map({ "n", "x" }, key, function()
		require("conform").format({ async = true, lsp_format = "fallback" })
	end, "Format")
end
for _, key in ipairs({ "<leader>9", "<leader>run" }) do
	map("n", key, function()
		if vim.bo.filetype ~= "python" then
			vim.notify("This shortcut runs Python files")
			return
		end
		vim.cmd.write()
		local file = vim.api.nvim_buf_get_name(0)
		vim.cmd.botright("12split")
		vim.cmd.enew()
		vim.fn.jobstart({ "python3", file }, { term = true })
		vim.cmd.startinsert()
	end, "Run Python in terminal")
end
map("n", "<leader>s", ":%s/", "Substitute with live preview", { silent = false })
map("n", "<leader>sp", "<cmd>GrugFar<cr>", "Project replace")
map("n", "<leader>sw", function()
	require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end, "Replace word in project")
map("n", "<leader>sf", function()
	require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
end, "Replace in current file")
map("n", "<leader>oa", org("agenda.prompt"), "Org agenda")
map("n", "<leader>oc", org("capture.prompt"), "Org capture")
map({ "n", "x" }, "<leader>ti", org("org_mappings.org_time_stamp"), "Org timestamp")
map("n", "<leader>tt", org("org_mappings.todo_next_state"), "Org TODO state")
map("n", "<leader>done", org("org_mappings.todo_next_state"), "Org TODO state")
map("n", "<leader>dead", org("org_mappings.org_deadline"), "Org deadline")
map("n", "<leader>sched", org("org_mappings.org_schedule"), "Org schedule")
map("n", "<leader>od", function()
	vim.fn.mkdir(vim.fn.expand("~/org"), "p")
	vim.cmd.edit(vim.fn.expand("~/org/") .. os.date("%Y-%m-%d") .. ".org")
end, "Today’s Org note")
map("n", "<leader>ts", function()
	vim.api.nvim_put({ os.date("%Y-%m-%d %H:%M:%S") }, "c", false, true)
end, "Insert timestamp")
local function encode(text)
	return (text:gsub("[^%w%-._~]", function(c)
		return string.format("%%%02X", string.byte(c))
	end))
end
for key, url in pairs({ dict = "https://www.dictionary.com/browse/", thes = "https://www.thesaurus.com/browse/" }) do
	map("n", "<leader>" .. key, function()
		vim.ui.open(url .. encode(vim.fn.expand("<cword>")))
	end, key .. " lookup")
end
map("x", "<leader>goog", function()
	local region = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
	vim.ui.open("https://www.google.com/search?q=" .. encode(table.concat(region, " ")))
end, "Google selected text")
map("n", "<leader>us", "<cmd>setlocal spell!<cr>", "Toggle spelling")
map("n", "<leader>uw", "<cmd>setlocal wrap!<cr>", "Toggle wrapping")
map("n", "<leader>gg", "<cmd>Git<cr>", "Git status")
