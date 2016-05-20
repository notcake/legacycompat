local self = {}
LegacyCompat.LuaFileSystem = LegacyCompat.MakeConstructor (self, LegacyCompat.IFileSystem)

function self:ctor ()
	self.BaseLuaPath        = ""
	self.BasePath           = ""
	self.VirtualBaseLuaPath = nil
	self.VirtualBasePath    = nil
end

function self:Exists (path, lua)
	return file.Exists (path, SERVER and "LSV" or "LCL")
end

function self:Find (path, lua)
	local files, folders = file.Find (path, SERVER and "LSV" or "LCL")
	for	_, v in ipairs (folders) do
		files [#files + 1] = v
	end
	return files
end

function self:IsFolder (path, lua)
	return file.IsDir (path, SERVER and "LSV" or "LCL")
end

function self:Read (path, lua)
	return file.Read (path, SERVER and "LSV" or "LCL")
end

function self:ToString ()
	return "[LuaFileSystem: " .. self:GetBaseLuaPath () .. " -> " .. self:GetVirtualBaseLuaPath () .. "]"
end

LegacyCompat.LuaFileSystem = LegacyCompat.LuaFileSystem ()