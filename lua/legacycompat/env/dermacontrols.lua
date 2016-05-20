local G = LegacyCompat.G

local function ImportDermaControls ()
	G.DFrame = _G.DFrame
end
ImportDermaControls ()
timer.Simple (0.001, ImportDermaControls)