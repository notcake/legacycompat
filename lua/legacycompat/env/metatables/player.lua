local Player = {}
Player.__base = "Entity"
LegacyCompat.R.Player = Player

function Player:__tostring ()
	return tostring (self)
end