local m = {}
m._VERSION = "0.0.0-dev"

local gcc = premake.tools.gcc
local config = premake.config

m.getlinks = gcc.getlinks

-- TODO: get rid of this whole file once premake5 has a sane way to do
-- this. 

-- premake5 alpha7 does not support passing `--start-group` and
-- `--end-group` to the linker which we want to use to not care about
-- the order of libraries, so we patch it back in here. This is based
-- on https://github.com/premake/premake-core/pull/353

-- See these discussions for further info:
-- https://github.com/premake/premake-core/issues/351 and
-- https://github.com/premake/premake-core/pull/273


function gcc.getlinks(cfg, systemonly)
	local result = {}

	if not systemonly then
		if cfg.flags.RelativeLinks then
			local libFiles = config.getlinks(cfg, "siblings", "basename")
			for _, link in ipairs(libFiles) do
				if string.find(link, "lib") == 1 then
					link = link:sub(4)
				end
				table.insert(result, "-l" .. link)
			end
		else
			-- Don't use the -l form for sibling libraries, since they may have
			-- custom prefixes or extensions that will confuse the linker. Instead
			-- just list out the full relative path to the library.
			result = config.getlinks(cfg, "siblings", "fullpath")
		end
	end

	if cfg.system ~= premake.MACOSX then
	   if #result > 1 then
		  table.insert(result, 1, "-Wl,--start-group")
		  table.insert(result, "-Wl,--end-group")
	   end
	end

	-- The "-l" flag is fine for system libraries

	local links = config.getlinks(cfg, "system", "fullpath")
	for _, link in ipairs(links) do
		if path.isframework(link) then
			table.insert(result, "-framework " .. path.getbasename(link))
		elseif path.isobjectfile(link) then
			table.insert(result, link)
		else
			table.insert(result, "-l" .. path.getname(link))
		end
	end

	return result
end

return m
