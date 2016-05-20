local Vehicle = {}
Vehicle.__base = "Entity"
LegacyCompat.R.Vehicle = Vehicle

function Vehicle:__tostring ()
	return tostring (self)
end