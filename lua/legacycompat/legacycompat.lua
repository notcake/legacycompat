if LegacyCompat then return end
LegacyCompat = {}

include ("lib.lua")
LegacyCompat.EventProvider (LegacyCompat)
LegacyCompat.AddCSLuaFolderRecursive ("legacycompat")

include ("filesets.lua")

include ("ifilesystem.lua")
include ("combinedfilesystem.lua")
include ("luafilesystem.lua")
include ("realfilesystem.lua")
include ("packfilesystem.lua")

include ("filesystem.lua")

include ("debug.lua")
include ("include.lua")
include ("metatableproxy.lua")

include ("global.lua")

LegacyCompat.IncludeDirectory ("legacycompat/filesethandlers")

function LegacyCompat.ExecuteFileSet (fileSet)
	if fileSet == LegacyCompat.FileSets.ClientAutoruns then
		for _, fileSystem in ipairs (LegacyCompat.FileSystems) do
			for _, fileName in ipairs (fileSystem:Find ("autorun/client/*.lua", true)) do
				LegacyCompat.IncludeAbsolutePath ("autorun/client/" .. fileName, fileSystem)
			end
		end
	elseif fileSet == LegacyCompat.FileSets.ServerAutoruns then
		for _, fileSystem in ipairs (LegacyCompat.FileSystems) do
			for _, fileName in ipairs (fileSystem:Find ("autorun/server/*.lua", true)) do
				LegacyCompat.IncludeAbsolutePath ("autorun/server/" .. fileName, fileSystem)
			end
		end
	elseif fileSet == LegacyCompat.FileSets.SharedAutoruns then
		for _, fileSystem in ipairs (LegacyCompat.FileSystems) do
			for _, fileName in ipairs (fileSystem:Find ("autorun/*.lua", true)) do
				LegacyCompat.IncludeAbsolutePath ("autorun/" .. fileName, fileSystem)
			end
		end
	else
		LegacyCompat.Error ("LegacyCompat.ExecuteFileSet : Unhandled file set (" .. LegacyCompat.FileSets [fileSet] .. ")")
	end
end

concommand.Add ("legacycompat_reload",
	function ()
		LegacyCompat:DispatchEvent ("Unloaded")
		LegacyCompat = nil
		if CLIENT then
			include ("autorun/client/legacycompat.lua")
		end
		if SERVER then
			include ("autorun/server/legacycompat.lua")
		end
		include ("autorun/legacycompat.lua")
	end
)