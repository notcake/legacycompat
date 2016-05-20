LegacyCompat.LegacyAddonPaths = {}
LegacyCompat.LegacyLuaPaths = {}
LegacyCompat.FileSystems = {}

local _, folders = file.Find ("addons/*", "GAME")
for _, folder in ipairs (folders) do
	if file.Exists ("addons/" .. folder .. "/info.txt", "GAME") and
	   not file.Exists ("addons/" .. folder .. "/addon.txt", "GAME") then
		LegacyCompat.LegacyAddonPaths [folder] = true
		
		local fileSystem = LegacyCompat.RealFileSystem ()
		fileSystem:SetBasePath ("addons/" .. folder .. "/")
		fileSystem:SetBaseLuaPath ("addons/" .. folder .. "/lua/")
		fileSystem:SetVirtualBaseLuaPath ("addons/" .. folder .. "/lua/")
		LegacyCompat.FileSystems [#LegacyCompat.FileSystems + 1] = fileSystem
	elseif file.IsDir ("addons/" .. folder .. "/lua/legacy", "GAME") then
		LegacyCompat.LegacyLuaPaths ["addons/" .. folder .. "/lua/legacy"] = true
		
		local fileSystem = LegacyCompat.RealFileSystem ()
		fileSystem:SetBasePath ("addons/" .. folder .. "/")
		fileSystem:SetBaseLuaPath ("addons/" .. folder .. "/lua/legacy/")
		fileSystem:SetVirtualBaseLuaPath ("addons/" .. folder .. "/lua/")
		LegacyCompat.FileSystems [#LegacyCompat.FileSystems + 1] = fileSystem
	end
end