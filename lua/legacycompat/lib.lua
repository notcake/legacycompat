if SERVER then
	function LegacyCompat.AddCSLuaFolder (folder, recursive)
		local files, folders = file.Find (folder .. "/*", "LUA")
		for _, fileName in pairs (files) do
			if fileName:sub (-4) == ".lua" then
				AddCSLuaFile (folder .. "/" .. fileName)
			end
		end
		if recursive then
			for _, childFolder in pairs (folders) do
				if childFolder ~= "." and childFolder ~= ".." then
					LegacyCompat.AddCSLuaFolder (folder .. "/" .. childFolder, recursive)
				end
			end
		end
	end

	function LegacyCompat.AddCSLuaFolderRecursive (folder)
		LegacyCompat.AddCSLuaFolder (folder, true)
	end
	
	function LegacyCompat.AddReloadCommand (includePath, systemName, systemTableName)
		includePath = includePath or (systemName .. "/" .. systemName .. ".lua")
		
		concommand.Add (systemName .. "_reload_sv", function (ply, _, arg)
			if ply and ply:IsValid () and not ply:IsSuperAdmin () then return end
		
			local startTime = SysTime ()
			LegacyCompat.UnloadSystem (systemTableName)
			include (includePath)
			LegacyCompat.Debug (systemName .. "_reload took " .. tostring ((SysTime () - startTime) * 1000) .. " ms.")
		end)
		concommand.Add (systemName .. "_reload_sh", function (ply, _, arg)
			if ply and ply:IsValid () and not ply:IsSuperAdmin () then return end
			
			local startTime = SysTime ()
			LegacyCompat.UnloadSystem (systemTableName)
			include (includePath)
			for _, ply in ipairs (player.GetAll ()) do
				ply:ConCommand (systemName .. "_reload")
			end
			LegacyCompat.Debug (systemName .. "_reload took " .. tostring ((SysTime () - startTime) * 1000) .. " ms.")
		end)
	end
elseif CLIENT then
	function LegacyCompat.AddCSLuaFolder (folder) end
	function LegacyCompat.AddCSLuaFolderRecursive (folder) end
	
	function LegacyCompat.AddReloadCommand (includePath, systemName, systemTableName)
		includePath = includePath or (systemName .. "/" .. systemName .. ".lua")
		
		concommand.Add (systemName .. "_reload", function (ply, _, arg)
			local startTime = SysTime ()
			LegacyCompat.UnloadSystem (systemTableName)
			include (includePath)
			LegacyCompat.Debug (systemName .. "_reload took " .. tostring ((SysTime () - startTime) * 1000) .. " ms.")
		end)
	end
else
	function LegacyCompat.AddCSLuaFolder (folder) end
	function LegacyCompat.AddCSLuaFolderRecursive (folder) end
	function LegacyCompat.AddReloadCommand (includePath, systemName, systemTableName) end
end

function LegacyCompat.Debug (message)
	MsgC (Color (128, 255, 128, 255), message .. "\n")
end

function LegacyCompat.Enum (enum)
	LegacyCompat.InvertTable (enum)
	return enum
end

function LegacyCompat.EnumerateDelayed (tbl, callback, finishCallback)
	if not callback then return end

	local next, tbl, key = pairs (tbl)
	local value = nil
	local function timerCallback ()
		key, value = next (tbl, key)
		if not key and finishCallback then finishCallback () return end
		callback (key, value)
		if not key then return end
		timer.Simple (0, timerCallback)
	end
	timer.Simple (0, timerCallback)
end

function LegacyCompat.Error (message)
	ErrorNoHalt (" \n\t" .. message .. "\n\t\t" .. LegacyCompat.StackTrace (nil, 2):gsub ("\n", "\n\t\t") .. "\n")
end

function LegacyCompat.FindUpValue (func, name)
	local i = 1
	local a, b = true, nil
	while a ~= nil do
		a, b = debug.getupvalue (func, i)
		if a == name then return b end
		i = i + 1
	end
end

function LegacyCompat.FormatDate (date)
	local dateTable = os.date ("*t", date)
	return string.format ("%02d/%02d/%04d %02d:%02d:%02d", dateTable.day, dateTable.month, dateTable.year, dateTable.hour, dateTable.min, dateTable.sec)
end

local units = { "B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB" }
function LegacyCompat.FormatFileSize (size)
	local unitIndex = 1
	while size >= 1024 do
		size = size / 1024
		unitIndex = unitIndex + 1
	end
	return tostring (math.floor (size * 100 + 0.5) / 100) .. " " .. units [unitIndex]
end

function LegacyCompat.GetMetaTable (constructor)
	local name, basetable = debug.getupvalue (constructor, 1)
	return basetable
end

function LegacyCompat.GetStackDepth ()
	local i = 0
	while debug.getinfo (i) do
		i = i + 1
	end
	return i
end

function LegacyCompat.Import (tbl)
	for k, v in pairs (LegacyCompat) do
		if type (v) == "function" then
			tbl [k] = v
		elseif type (v) == "table" then
			tbl [k] = {}
			tbl [k].__index = v
			setmetatable (tbl [k], tbl [k])
		end
	end
end

function LegacyCompat.IncludeDirectory (folder, recursive)
	local included = {}
	local paths = { "LUA", SERVER and "LSV" or "LCL" }
	
	for _, path in ipairs (paths) do
		local files, folders = file.Find (folder .. "/*", path)
		for _, file in ipairs (files) do
			if file:sub (-4):lower () == ".lua" and
			   not included [file:lower ()] then
				include (folder .. "/" .. file)
				included [file:lower ()] = true
			end
		end
		if recursive then
			for _, childFolder in ipairs (folders) do
				if childFolder ~= "." and childFolder ~= ".." and
				   not included [childFolder:lower ()] then
					LegacyCompat.IncludeDirectory (folder .. "/" .. childFolder, recursive)
					included [childFolder:lower ()] = true
				end
			end
		end
	end
end

function LegacyCompat.InvertTable (tbl)
	local keys = {}
	for key, Value in pairs (tbl) do
		keys [#keys + 1] = key
	end
	for i = 1, #keys do
		tbl [tbl [keys [i]]] = keys [i]
	end
end

--[[
	LegacyCompat.MakeConstructor (metatable, base, base2)
		Returns: ()->Object
		
		Produces a constructor for the object defined by metatable.
		base may be nil or the constructor of a base class.
		base2 may be nil or the constructor of another base class.
		The second base class must not be a class with inheritance.
]]
function LegacyCompat.MakeConstructor (metatable, base, base2)
	metatable.__index = metatable
	
	if base then
		local basetable = LegacyCompat.GetMetaTable (base)
		metatable.__base = basetable
		setmetatable (metatable, basetable)
		
		if base2 then
			local base2table = base2
			if type (base2) == "function" then base2table = LegacyCompat.GetMetaTable (base2) end
			for k, v in pairs (base2table) do
				if k:sub (1, 2) ~= "__" then metatable [k] = v end
			end
			metatable.ctor2 = base2table.ctor
		end
	end
	
	return function (...)
		local object = {}
		setmetatable (object, metatable)
		
		-- Create constructor and destructor
		if not rawget (metatable, "__ctor") or not rawget (metatable, "__dtor") then
			local base = metatable
			local ctors = {}
			local dtors = {}
			while base ~= nil do
				ctors [#ctors + 1] = rawget (base, "ctor")
				ctors [#ctors + 1] = rawget (base, "ctor2")
				dtors [#dtors + 1] = rawget (base, "dtor")
				base = base.__base
			end
			
			function metatable:__ctor (...)
				for i = #ctors, 1, -1 do
					ctors [i] (self, ...)
				end
			end
			function metatable:__dtor (...)
				for i = 1, #dtors do
					dtors [i] (self, ...)
				end
			end
		end
		
		object.dtor = object.__dtor
		object:__ctor (...)
		return object
	end
end

function LegacyCompat.PrettifyString (str)
	local out = ""
	for i = 1, str:len () do
		local char = str:sub (i, i)
		local byte = string.byte (char)
		if byte < 32 or byte >= 127 then
			out = out .. string.format ("[%02x]", byte)
		else
			out = out .. char
		end
	end
	return out
end

function LegacyCompat.PrintStackTrace ()
	ErrorNoHalt (LegacyCompat.StackTrace (nil, 2))
end

function LegacyCompat.StackTrace (levels, offset)
	local stringBuilder = LegacyCompat.StringBuilder ()
	
	local offset = offset or 1
	local exit = false
	local i = 0
	local shown = 0
	while not exit do
		local t = debug.getinfo (i)
		if not t or shown == levels then
			exit = true
		else
			local name = t.name
			local src = t.short_src
			src = src or "<unknown>"
			if i >= offset then
				shown = shown + 1
				if name then
					stringBuilder:Append (string.format ("%2d", i) .. ": " .. name .. " (" .. src .. ": " .. tostring (t.currentline) .. ")\n")
				else
					if src and t.currentline then
						stringBuilder:Append (string.format ("%2d", i) .. ": (" .. src .. ": " .. tostring (t.currentline) .. ")\n")
					else
						stringBuilder:Append (string.format ("%2d", i) .. ":\n")
						PrintTable (t)
					end
				end
			end
		end
		i = i + 1
	end
	return stringBuilder:ToString ()
end

function LegacyCompat.UnloadSystem (systemTableName)
	if not systemTableName then return end
	if type (_G [systemTableName]) == "table" and
		type (_G [systemTableName].DispatchEvent) == "function" then
		_G [systemTableName]:DispatchEvent ("Unloaded")
	end
	_G [systemTableName] = nil
end

function LegacyCompat.WeakTable ()
	local tbl = {}
	setmetatable (tbl, { __mode = "kv" })
	return tbl
end

function LegacyCompat.WeakKeyTable ()
	local tbl = {}
	setmetatable (tbl, { __mode = "k" })
	return tbl
end

function LegacyCompat.WeakValueTable ()
	local tbl = {}
	setmetatable (tbl, { __mode = "v" })
	return tbl
end

include ("eventprovider.lua")
include ("stringbuilder.lua")