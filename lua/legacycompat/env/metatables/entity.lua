local Entity = {}
LegacyCompat.R.Entity = Entity

function Entity:GetColor ()
	local c = self:GetColor ()
	return c.r, c.g, c.b, c.a
end

function Entity:__tostring ()
	return tostring (self)
end