local pathInfo = {}

local function GetPathInfo (fullLuaPath)
	return pathInfo [fullLuaPath]
end

local function SetPathInfo (fullLuaPath, fileSystem, luaPath)
	pathInfo [fullLuaPath] =
	{
		FileSystem = fileSystem,
		LuaPath    = luaPath
	}
end

local function GetPathFolder (path)
	path = path:gsub ("\\", "/")
	path = path:gsub ("/+", "/")
	return path:sub (1, path:find ("/[^/]*$"))
end

local function CreateFunctionInfo (f, source)
	local ref = debug.getinfo (f)
	
	local t = {}
	t.linedefined     = ref.linedefined
	t.currentline     = -1
	t.lastlinedefined = ref.lastlinedefined
	t.func            = f
	t.source          = source and ("@" .. source) or "=[C]"
	t.nups            = 0
	t.what            = "C"
	t.namewhat        = ""
	t.short_src       = source or "[C]"
	return t
end

function LegacyCompat.Include (relativePath)
	local fullLuaPath = debug.getinfo (3).short_src
	local pathInfo = GetPathInfo (fullLuaPath)
	local fileSystem = pathInfo.FileSystem
	local luaPath    = pathInfo.LuaPath
	
	if fileSystem:Exists (GetPathFolder (luaPath) .. relativePath, true) then
		LegacyCompat.IncludeAbsolutePath (GetPathFolder (luaPath) .. relativePath, fileSystem)
	elseif fileSystem:Exists (relativePath, true) then
		LegacyCompat.IncludeAbsolutePath (relativePath, fileSystem)
	else
		local found = false
		for _, fileSystem in ipairs (LegacyCompat.FileSystems) do
			if fileSystem:Exists (GetPathFolder (luaPath) .. relativePath, true) then
				LegacyCompat.IncludeAbsolutePath (GetPathFolder (luaPath) .. relativePath, fileSystem)
				found = true
				break
			elseif fileSystem:Exists (relativePath, true) then
				LegacyCompat.IncludeAbsolutePath (relativePath, fileSystem)
				found = true
				break
			end
		end
		
		if not found then
			if LegacyCompat.LuaFileSystem:Exists (GetPathFolder (luaPath) .. relativePath, true) then
				LegacyCompat.IncludeAbsolutePath (GetPathFolder (luaPath) .. relativePath, LegacyCompat.LuaFileSystem)
				found = true
			elseif LegacyCompat.LuaFileSystem:Exists (relativePath, true) then
				LegacyCompat.IncludeAbsolutePath (relativePath, LegacyCompat.LuaFileSystem)
				found = true
			end
		end
		
		if not found then
			LegacyCompat.Error ("LegacyCompat.Include : Path \"" .. relativePath .. "\" not found.")
		end
	end
end

function LegacyCompat.IncludeAbsolutePath (luaPath, fileSystem)
	local fullLuaPath = fileSystem:GetVirtualBaseLuaPath () .. luaPath
	
	local code = fileSystem:Read (luaPath, true)
	local f = CompileString (code, fullLuaPath)
	
	debug.setfenv (f, LegacyCompat.G)
	SetPathInfo (fullLuaPath, fileSystem, luaPath)
	LegacyCompat.SetFunctionInfo (f, CreateFunctionInfo (f, fullLuaPath))
	
	-- LegacyCompat.Debug ("LegacyCompat.IncludeRealPath (" .. luaPath .. ")")
	xpcall (f, LegacyCompat.Error)
end