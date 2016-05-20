local timer = {}
LegacyCompat.G.timer = timer
LegacyCompat.Timers = {}

LegacyCompat:AddEventListener ("Unloaded", "timer.Cleanup",
	function ()
		for timerName, _ in pairs (LegacyCompat.Timers) do
			_G.timer.Destroy (timerName)
		end
	end
)

function timer.Create (timerName, interval, count, f, ...)
	timerName = tostring (timerName)
	interval  = tonumber (interval)
	if not interval then return end
	if not count    then return end
	
	local args = {...}
	
	LegacyCompat.Timers [timerName] = true
	_G.timer.Create (timerName, interval, count,
		function ()
			xpcall (f,
				function (msg)
					msg = tostring (msg)
					_G.timer.Destroy (timerName)
					LegacyCompat.Error ("Error in timer \"" .. timerName .. "\" : " .. msg .. ", removing.")
				end,
				unpack (args)
			)
		end
	)
end

function timer.Destroy (timerName)
	LegacyCompat.Timers [timerName] = nil
	_G.timer.Destroy (timerName)
end

function timer.IsTimer (timerName)
	return _G.timer.Exists (tostring (timerName))
end

function timer.Simple (interval, f, ...)
	interval = tonumber (interval)
	if not interval then return end
	
	local args = {...}
	
	_G.timer.Simple (interval,
		function ()
			xpcall (f, LegacyCompat.Error, unpack (args))
		end
	)
end