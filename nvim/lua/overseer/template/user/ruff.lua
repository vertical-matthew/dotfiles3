return {
	name = "Python: lint project",
	builder = function()
		return { cmd = { "ruff", "check", "." }, cwd = require("core.project").root(), components = { "default" } }
	end,
}
