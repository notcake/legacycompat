local util = {}
LegacyCompat.G.util = util

for k, v in pairs (_G.util) do
	util [k] = v
end

function util.TraceLine (...)
	local t = _G.util.TraceLine (...)
	t.Entity = LegacyCompat.WrapObject (t.Entity)
	return t
end