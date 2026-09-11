return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		event = { "InsertEnter", "CmdlineEnter" },
		opts = {
			keymap = {
				preset = "default",
				["<CR>"] = { "accept", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<Tab>"] = { "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
			},
			completion = {
				menu = { draw = { columns = { { "label", "label_description", gap = 1 }, { "kind" } } } },
				list = { selection = { preselect = false, auto_insert = false } },
				documentation = { auto_show = true },
			},
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "saghen/blink.cmp" },
		config = function()
			vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})
			for server, executable in pairs({
				pyright = "pyright-langserver",
				ruff = "ruff",
				lua_ls = "lua-language-server",
				sourcekit = "sourcekit-lsp",
			}) do
				if vim.fn.executable(executable) == 1 then
					vim.lsp.enable(server)
				end
			end
			vim.diagnostic.config({
				signs = { text = { [1] = "E", [2] = "W", [3] = "I", [4] = "H" } },
				severity_sort = true,
				virtual_text = false,
				underline = true,
				float = { border = "rounded", source = true },
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				python = { "ruff_organize_imports", "ruff_format" },
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				markdown = { "prettier" },
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({ install_dir = vim.fn.stdpath("data") .. "/dotfiles3/treesitter" })
		end,
	},
}
