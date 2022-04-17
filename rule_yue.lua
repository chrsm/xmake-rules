rule("yue")
do
	set_extensions(".yue")

	on_build_file(function(target, src, opt)
		import("core.project.depend")
		import("utils.progress")
		local reldir = path.directory((path.relative(src, "src")))
		if reldir == "." then
			reldir = ""
		end

		local dir = path.join(target:targetdir(), reldir)
		local file = path.join(dir, (path.basename(src)) .. ".lua")
		local relpath = path.relative(src, "src")
		os.mkdir(dir)

		return depend.on_changed(
			function()
				local absfile = path.absolute(file)
				local old = os.cd("src")
				os.setenv("LUA_PATH", "./?.lua;./?/init.lua")
				os.vrunv("yue", {
					"-l",
					"-s",
					"-o",
					absfile,
					relpath,
				})
				os.cd(old)
				progress.show(opt.progress, "${ color.build.object }yue %s", src)
			end,
			{
				files = src,
			}
		)
	end)
end
