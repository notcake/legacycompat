local math = {}
LegacyCompat.G.math = math

for k, v in pairs (_G.math) do
	math [k] = v
end