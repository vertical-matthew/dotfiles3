return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = "markdown",
		opts = {
			heading = { icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " }, sign = false },
			code = { sign = false, language_icon = false },
			bullet = { icons = { "-", "*", "+" } },
			checkbox = { unchecked = { icon = "[ ] " }, checked = { icon = "[x] " } },
			sign = { enabled = false },
			link = { enabled = false },
		},
		keys = { { "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown presentation" } },
	},
}
