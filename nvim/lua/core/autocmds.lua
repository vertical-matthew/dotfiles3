local group = vim.api.nvim_create_augroup("Dotfiles3", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	callback = function()
		vim.hl.on_yank({ timeout = 150 })
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function(args)
		vim.opt_local.formatoptions:remove({ "t", "o" })
		if vim.tbl_contains({ "markdown", "text", "org", "gitcommit" }, args.match) then
			vim.opt_local.spell = true
		end
		if vim.tbl_contains({ "lua", "json", "javascript", "typescript", "html", "css" }, args.match) then
			vim.opt_local.shiftwidth = 2
			vim.opt_local.softtabstop = 2
		end
		if vim.bo[args.buf].buftype == "" and vim.api.nvim_buf_line_count(args.buf) < 20000 then
			if pcall(vim.treesitter.start, args.buf) then
				vim.opt_local.foldmethod = "expr"
				vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			end
		end
	end,
})
vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(args)
		local function map(key, fn, desc)
			vim.keymap.set("n", key, fn, { buffer = args.buf, desc = desc })
		end
		map("gd", vim.lsp.buf.definition, "Definition")
		map("gy", vim.lsp.buf.type_definition, "Type definition")
		map("gi", vim.lsp.buf.implementation, "Implementation")
		map("gr", vim.lsp.buf.references, "References")
		map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
		map("<leader>qf", vim.lsp.buf.code_action, "Code action")
		map("<leader>lk", vim.lsp.buf.hover, "Hover documentation (K remains paragraph)")
	end,
})
