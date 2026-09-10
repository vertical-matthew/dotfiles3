return {
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("gruvbox").setup({})
			vim.cmd.colorscheme("gruvbox")
		end,
	},
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = { theme = "gruvbox", globalstatus = true },
			sections = { lualine_c = { { "filename", path = 1 } } },
		},
	},
	{
		"romgrk/barbar.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = { animation = false },
	},
	{ "folke/which-key.nvim", event = "VeryLazy", opts = { delay = 400 } },
	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			view_options = { show_hidden = true },
			delete_to_trash = true,
			skip_confirm_for_simple_edits = false,
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			require("telescope").setup({
				defaults = { file_ignore_patterns = { "node_modules/", "%.git/" } },
				pickers = { find_files = { hidden = true } },
			})
			require("telescope").load_extension("fzf")
		end,
	},
	{ "smoka7/hop.nvim", cmd = { "HopWord", "HopLine", "HopPattern" }, opts = {} },
	{ "mbbill/undotree", cmd = "UndotreeToggle" },
	{ "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" }, opts = {} },
	{ "tpope/vim-fugitive", cmd = { "Git", "G", "Gdiffsplit", "Gwrite", "Gread" } },
	{ "tpope/vim-surround", event = "VeryLazy" },
	{ "tpope/vim-repeat", event = "VeryLazy" },
	{ "rhysd/clever-f.vim", event = "VeryLazy" },
	{ "echasnovski/mini.ai", event = "VeryLazy", opts = {} },
	{ "echasnovski/mini.pairs", event = "InsertEnter", opts = {} },
	{ "echasnovski/mini.move", event = "VeryLazy", opts = {} },
	{
		"echasnovski/mini.indentscope",
		event = { "BufReadPost", "BufNewFile" },
		opts = { draw = {
			delay = 100,
			animation = function()
				return 0
			end,
		} },
	},
	{
		"gbprod/yanky.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-telescope/telescope.nvim" },
		opts = { ring = { history_length = 1000 } },
		config = function(_, opts)
			require("yanky").setup(opts)
			require("telescope").load_extension("yank_history")
			vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
		end,
	},
	{ "folke/zen-mode.nvim", cmd = "ZenMode", opts = { window = { width = 90 } } },
	{ "folke/twilight.nvim", cmd = "Twilight", opts = {} },
	{ "MagicDuck/grug-far.nvim", cmd = "GrugFar", opts = {} },
	{
		"nvim-orgmode/orgmode",
		ft = "org",
		cmd = "Org",
		opts = {
			org_agenda_files = { "~/org/**/*" },
			org_default_notes_file = "~/org/refile.org",
			org_capture_templates = {
				t = { description = "Task", template = "* TODO %?\n  %u", target = "~/org/tasks.org" },
				j = { description = "Journal", template = "* %<%Y-%m-%d> %U\n\n  %?", target = "~/org/journal.org" },
			},
		},
	},
}
