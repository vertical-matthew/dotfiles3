local plain_keys = {
	Up = "Up",
	Down = "Down",
	Left = "Left",
	Right = "Right",
	C = "Ctrl-",
	M = "Alt-",
	D = "Cmd-",
	S = "Shift-",
	CR = "Enter",
	Esc = "Esc",
	ScrollWheelDown = "ScrollDown",
	ScrollWheelUp = "ScrollUp",
	NL = "Enter",
	BS = "Backspace",
	Space = "Space",
	Tab = "Tab",
}
for i = 1, 12 do
	plain_keys["F" .. i] = "F" .. i
end
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
			options = {
				theme = "gruvbox",
				globalstatus = true,
				icons_enabled = false,
				component_separators = "|",
				section_separators = "",
			},
			sections = {
				lualine_b = {
					{ "branch", icon = "" },
					"diff",
					{ "diagnostics", symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" } },
				},
				lualine_c = { { "filename", path = 1 } },
			},
		},
	},
	{
		"romgrk/barbar.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			animation = false,
			icons = {
				filetype = { enabled = false },
				button = "x",
				modified = { button = "*" },
				separator = { left = "|", right = "" },
				scroll = { left = "<", right = ">" },
			},
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			delay = 400,
			icons = { mappings = false, breadcrumb = ">", separator = "->", group = "+", keys = plain_keys },
		},
	},
	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			columns = { "permissions", "size" },
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
				defaults = {
					file_ignore_patterns = { "node_modules/", "%.git/" },
					prompt_prefix = "> ",
					selection_caret = "> ",
					entry_prefix = "  ",
					disable_devicons = true,
				},
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
	-- Neovim 0.12 returns nil for missing parsers; Twilight's TS path assumes a parser.
	{ "folke/twilight.nvim", cmd = "Twilight", opts = { treesitter = false } },
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
