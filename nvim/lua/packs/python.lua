return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"<leader>Db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle breakpoint",
			},
			{
				"<leader>Dc",
				function()
					require("dap").continue()
				end,
				desc = "Start/continue debugger",
			},
			{
				"<leader>Dn",
				function()
					require("dap").step_over()
				end,
				desc = "Debug step over",
			},
			{
				"<leader>Di",
				function()
					require("dap").step_into()
				end,
				desc = "Debug step into",
			},
			{
				"<leader>Do",
				function()
					require("dap").step_out()
				end,
				desc = "Debug step out",
			},
			{
				"<leader>Dq",
				function()
					require("dap").terminate()
				end,
				desc = "Stop debugger",
			},
			{
				"<leader>Du",
				function()
					require("dapui").toggle()
				end,
				desc = "Debugger panels",
			},
			{
				"<leader>De",
				function()
					require("dapui").eval()
				end,
				desc = "Inspect expression",
				mode = { "n", "x" },
			},
			{
				"<leader>pv",
				function()
					require("core.python").pick()
				end,
				desc = "Select project Python",
			},
		},
		dependencies = {
			"mfussenegger/nvim-dap-python",
			{ "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
		},
		config = function()
			local dap, ui = require("dap"), require("dapui")
			ui.setup({
				icons = { expanded = "-", collapsed = "+", current_frame = ">" },
				controls = { enabled = false },
			})
			require("dap-python").setup(vim.fn.stdpath("data") .. "/dotfiles3/python/bin/python")
			require("dap-python").resolve_python = function()
				return require("core.python").executable()
			end
			dap.listeners.after.event_initialized.dotfiles3 = function()
				ui.open()
			end
			vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DiagnosticError" })
			vim.fn.sign_define("DapStopped", { text = ">", texthl = "DiagnosticWarn" })
		end,
	},
	{
		"nvim-neotest/neotest",
		dependencies = { "nvim-neotest/nvim-nio", "nvim-lua/plenary.nvim", "nvim-neotest/neotest-python" },
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						python = function(root)
							return require("core.python").executable(root .. "/placeholder.py")
						end,
						runner = "pytest",
						dap = { justMyCode = false },
					}),
				},
				icons = {
					passed = "P",
					failed = "F",
					running = "R",
					skipped = "S",
					unknown = "?",
					non_collapsible = " ",
					collapsed = "+",
					expanded = "-",
					child_prefix = "|",
					final_child_prefix = "`",
					child_indent = " ",
					watching = "W",
					running_animated = { ".", "o", "O" },
				},
			})
		end,
		keys = {
			{
				"<leader>Tn",
				function()
					require("neotest").run.run()
				end,
				desc = "Test nearest",
			},
			{
				"<leader>Tf",
				function()
					require("neotest").run.run(vim.fn.expand("%:p"))
				end,
				desc = "Test file",
			},
			{
				"<leader>Ta",
				function()
					require("neotest").run.run(require("core.project").root())
				end,
				desc = "Test project",
			},
			{
				"<leader>Ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Test summary",
			},
			{
				"<leader>To",
				function()
					require("neotest").output.open({ enter = true })
				end,
				desc = "Test output",
			},
			{
				"<leader>Tl",
				function()
					require("neotest").run.run_last()
				end,
				desc = "Rerun last tests",
			},
		},
	},
}
