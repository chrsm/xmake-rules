rule("custgolang")
do
	set_extensions(".go")
	on_link(function()
		return nil
	end)

	on_build_file(function(target, files, opt)
		import("core.project.depend")
		import("utils.progress")
		os.mkdir(target:targetdir())

		local relp = path.join(target:targetdir(), (path.basename(target:name())))
		if target:is_plat("windows") then
			relp = relp .. ".exe"
		end

		return depend.on_changed(
			function()
				os.vrunv("go", {
					"build",
					"-v",
					"-o",
					relp,
					target:name(),
				})
			end,
			{
				dependfile = (target:dependfile(relp)),
				files = files,
				always_changed = false,
			}
		)
	end)
end
