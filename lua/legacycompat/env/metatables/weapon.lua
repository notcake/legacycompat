local Weapon = {}
Weapon.__base = "Entity"
LegacyCompat.R.Weapon = Weapon

function Weapon:__tostring ()
	return tostring (self)
end