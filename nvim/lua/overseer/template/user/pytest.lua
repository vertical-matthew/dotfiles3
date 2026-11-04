return {
	name = "Python: test project",
	builder = function()
		return {
			cmd = { require("core.python").executable(), "-m", "pytest" },
			cwd = require("core.project").root(),
			components = { "default" },
		}
	end,
}
