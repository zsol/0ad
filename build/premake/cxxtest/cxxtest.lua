local m = {}
m._VERSION = "0.0.0-dev"

m.path = nil

function m.configure_project(rootfile, hdrfiles, rootoptions, testoptions)
	if rootoptions == nil then
		rootoptions = ''
	end
	if testoptions == nil then
		testoptions = ''
	end
	local cmds = {}
	local abspath = path.getabsolute(m.path)

	for _,hdrfile in ipairs(hdrfiles) do
		hdrfile = path.getabsolute(hdrfile)
		local srcfile = string.sub(hdrfile, 1, -3) .. ".cpp"
		files { hdrfile, srcfile }
		table.insert(cmds, abspath .. " --part " .. testoptions .. " -o " .. srcfile .. " " .. hdrfile)
	end
	rootfile = path.getabsolute(rootfile)
	files { rootfile }
	table.insert(cmds, abspath .. " --root " .. rootoptions .. " -o " .. rootfile)
	prebuildcommands {cmds}
end

cxxtest = m
return m
