local hook = {}
LegacyCompat.G.hook = hook
LegacyCompat.Hooks = {}

LegacyCompat:AddEventListener ("Unloaded", "hook.Cleanup",
	function ()
		for hookName, t in pairs (LegacyCompat.Hooks) do
			for functionName, _ in pairs (t) do
				_G.hook.Remove (hookName, functionName)
			end
		end
	end
)

function hook.Add (hookName, functionName, f)
	hookName     = tostring (hookName)
	functionName = tostring (functionName)
	if type (f) ~= "function" then
		LegacyCompat.Error ("hook.Add (\"" .. hookName .. "\":\"" .. functionName .. "\") : Expected a function got a " .. type (f) .. " instead (" .. tostring (f) .. ")")
		return
	end
	
	LegacyCompat.Hooks [hookName] = LegacyCompat.Hooks [hookName] or {}
	LegacyCompat.Hooks [hookName] [functionName] = true
	_G.hook.Add (hookName, functionName,
		function (...)
			xpcall (f,
				function (msg)
					msg = tostring (msg)
					_G.hook.Remove (hookName, functionName)
					LegacyCompat.Error ("Error in hook \"" .. hookName .. "\":\"" .. functionName .. "\" : " .. msg .. ", removing.")
				end,
				...
			)
		end
	)
end

function hook.Call (...)
	return _G.hook.Call (...)
end

function hook.GetTable ()
	return table.Copy (_G.hook.GetTable ())
end

function hook.Remove (hookName, functionName)
	hookName     = tostring (hookName)
	functionName = tostring (functionName)
	
	if LegacyCompat.Hooks [hookName] then
		LegacyCompat.Hooks [hookName] [functionName] = nil
		if not next (LegacyCompat.Hooks [hookName]) then
			LegacyCompat.Hooks [hookName] = nil
		end
	end
	_G.hook.Remove (hookName, functionName)
end