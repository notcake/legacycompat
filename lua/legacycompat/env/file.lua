local file  = {}
local filex = {}
LegacyCompat.G.file = file
LegacyCompat.G.filex = filex

function file.Append (path, data)
	_G.file.Write (path, (_G.file.Read ("data/" .. path, "GAME") or "") .. data)
end
filex.Append = file.Append

function file.Exists (path, fromGameDir)
	if fromGameDir then
		return _G.file.Exists (path, "GAME")
	end
	return _G.file.Exists ("data/" .. path, "GAME")
end

function file.Find (path, fromGameDir)
	local files, folders = nil, nil
	if fromGameDir then
		files, folders = _G.file.Find (path, "GAME")
	else
		files, folders = _G.file.Find ("data/" .. path, "GAME")
	end
	for _, v in ipairs (folders) do
		files [#files + 1] = v
	end
	return files
end

function file.FindInLua (path)
	return LegacyCompat.CombinedFileSystem:Find (path, true)
end

function file.IsDir (path)
	return LegacyCompat.CombinedFileSystem:IsFolder (path)
end

function file.Read (path, fromGameDir)
	if fromGameDir then
		return _G.file.Read (path, "GAME")
	end
	return _G.file.Read ("data/" .. path, "GAME")
end

function file.Write (path, data)
	return _G.file.Write (path, data)
end