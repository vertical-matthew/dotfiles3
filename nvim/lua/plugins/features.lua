local specs = {}
for _, pack in ipairs({ "workspace", "coding", "python", "web", "writing", "git" }) do
	if require("features")[pack] then
		vim.list_extend(specs, require("packs." .. pack))
	end
end
return specs
