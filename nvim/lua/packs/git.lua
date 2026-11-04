return {
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
		opts = { use_icons = false, signs = { fold_closed = "+", fold_open = "-", done = "*" } },
		keys = {
			{ "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Review changes" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Current file history" },
			{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close change review" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			on_attach = function(buf)
				local gs = require("gitsigns")
				local function map(key, fn, desc)
					vim.keymap.set("n", key, fn, { buffer = buf, desc = desc })
				end
				map("]c", function()
					gs.nav_hunk("next")
				end, "Next Git change")
				map("[c", function()
					gs.nav_hunk("prev")
				end, "Previous Git change")
				map("<leader>gp", gs.preview_hunk, "Preview Git change")
				map("<leader>gs", gs.stage_hunk, "Stage current Git change")
				map("<leader>gb", gs.blame_line, "Explain line history")
			end,
		},
	},
}
