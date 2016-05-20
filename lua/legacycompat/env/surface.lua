if not CLIENT then return end

local surface  = {}
LegacyCompat.G.surface = surface

for k, v in pairs (_G.surface) do
	surface [k] = v
end

function surface.SetFont (font)
	if font == "ScoreboardText" then
		font = "DermaDefaultBold"
	end
	_G.surface.SetFont (font)
end