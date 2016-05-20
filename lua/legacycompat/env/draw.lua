if not CLIENT then return end

local draw  = {}
LegacyCompat.G.draw = draw

for k, v in pairs (_G.draw) do
	draw [k] = v
end

function draw.SimpleText (text, font, x, y, color, xalign, yalign)
	if font == "ScoreboardText" then
		font = "DermaDefaultBold"
	end
	_G.draw.SimpleText (text, font, x, y, color, xalign, yalign)
end