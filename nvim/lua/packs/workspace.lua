return {
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
		keys = {
			{
				"<leader>ps",
				function()
					require("persistence").load()
				end,
				desc = "Restore project session",
			},
			{
				"<leader>pS",
				function()
					require("persistence").select()
				end,
				desc = "Choose saved session",
			},
			{
				"<leader>pl",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore last session",
			},
		},
	},
	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 900,
		opts = {
			bigfile = { enabled = true, size = 1024 * 1024 },
			input = { enabled = true, icon = "> " },
			notifier = {
				enabled = true,
				timeout = 3000,
				icons = { error = "E", warn = "W", info = "I", debug = "D", trace = "T" },
			},
			terminal = { enabled = true, win = { position = "bottom", height = 0.3 } },
		},
		keys = {
			{
				"<leader>pt",
				function()
					require("snacks").terminal.toggle(nil, { cwd = require("core.project").root() })
				end,
				desc = "Toggle project terminal",
			},
			{
				"<leader>pn",
				function()
					require("snacks").notifier.show_history()
				end,
				desc = "Notification history",
			},
			{
				"<leader>pr",
				function()
					vim.notify(require("core.project").root())
				end,
				desc = "Show project root",
			},
			{
				"<leader>fp",
				function()
					require("telescope.builtin").find_files({ cwd = require("core.project").root() })
				end,
				desc = "Find project files",
			},
			{
				"<leader>fG",
				function()
					require("telescope.builtin").live_grep({ cwd = require("core.project").directory() })
				end,
				desc = "Grep current directory",
			},
		},
	},
	{
		"stevearc/overseer.nvim",
		cmd = { "OverseerRun", "OverseerToggle" },
		opts = { templates = { "builtin", "user.pytest", "user.ruff" } },
		keys = {
			{ "<leader>po", "<cmd>OverseerRun<cr>", desc = "Run named project task" },
			{ "<leader>pO", "<cmd>OverseerToggle<cr>", desc = "Task status and output" },
		},
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		config = function(_, opts)
			require("harpoon"):setup(opts)
		end,
		keys = {
			{
				"<leader>ba",
				function()
					require("harpoon"):list():add()
				end,
				desc = "Pin current file",
			},
			{
				"<leader>bb",
				function()
					local h = require("harpoon")
					h.ui:toggle_quick_menu(h:list())
				end,
				desc = "Edit pinned files",
			},
			{
				"<leader>b1",
				function()
					require("harpoon"):list():select(1)
				end,
				desc = "Pinned file 1",
			},
			{
				"<leader>b2",
				function()
					require("harpoon"):list():select(2)
				end,
				desc = "Pinned file 2",
			},
			{
				"<leader>b3",
				function()
					require("harpoon"):list():select(3)
				end,
				desc = "Pinned file 3",
			},
			{
				"<leader>b4",
				function()
					require("harpoon"):list():select(4)
				end,
				desc = "Pinned file 4",
			},
		},
	},
}
