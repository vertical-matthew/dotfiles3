return {
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = {
			icons = {
				indent = { top = "| ", middle = "| ", last = "` ", fold_open = "- ", fold_closed = "+ ", ws = "  " },
				folder_closed = "+",
				folder_open = "-",
				kinds = {},
			},
		},
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Reported project diagnostics" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Current buffer diagnostics" },
			{ "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix results" },
		},
	},
	{ "saghen/blink.cmp", dependencies = { "rafamadriz/friendly-snippets" } },
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = "VeryLazy",
		opts = { select = { lookahead = true }, move = { set_jumps = true } },
		config = function(_, opts)
			require("nvim-treesitter-textobjects").setup(opts)
			for key, query in pairs({
				am = "@function.outer",
				im = "@function.inner",
				ac = "@class.outer",
				ic = "@class.inner",
			}) do
				vim.keymap.set({ "x", "o" }, key, function()
					require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
				end, { desc = query })
			end
			for key, action in pairs({ ["]m"] = "goto_next_start", ["[m"] = "goto_previous_start" }) do
				vim.keymap.set({ "n", "x", "o" }, key, function()
					require("nvim-treesitter-textobjects.move")[action]("@function.outer", "textobjects")
				end, { desc = "Navigate function" })
			end
			vim.keymap.set("n", "<leader>ca", function()
				require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
			end, { desc = "Swap argument forward" })
			vim.keymap.set("n", "<leader>cA", function()
				require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
			end, { desc = "Swap argument backward" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPost",
		opts = {
			max_lines = 3,
			on_attach = function(buf)
				return vim.bo[buf].buftype == "" and not vim.b[buf].bigfile
			end,
		},
	},
	{
		"stevearc/aerial.nvim",
		cmd = "AerialToggle",
		opts = { backends = { "lsp", "treesitter", "markdown" }, icons = {}, show_guides = false },
		keys = { { "<leader>co", "<cmd>AerialToggle<cr>", desc = "Toggle code outline" } },
	},
}
