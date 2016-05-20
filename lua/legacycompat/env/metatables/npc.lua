local NPC = {}
NPC.__base = "Entity"
LegacyCompat.R.NPC = NPC

function NPC:__tostring ()
	return tostring (self)
end