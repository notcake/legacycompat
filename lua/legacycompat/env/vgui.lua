if not CLIENT then return end

local vgui = {}
LegacyCompat.G.vgui = vgui
LegacyCompat.VGUIPanels = LegacyCompat.WeakTable ()

LegacyCompat:AddEventListener ("Unloaded", "vgui.Cleanup",
	function ()
		for k, _ in pairs (LegacyCompat.VGUIPanels) do
			if k:IsValid () then k:Remove () end
		end
	end
)

local controlClassMap =
{
	DComboBox    = "DListBox",
	DMultiChoice = "DComboBox"
}

local function FixupPanel (panel, className)
	local AddSheet     = panel.AddSheet
	local GetImage     = panel.GetImage
	local GetItems     = panel.GetItems
	local SetImage     = panel.SetImage
	local SetTextInset = panel.SetTextInset
	function panel:AddSheet (label, panel, icon, noStretchX, noStretchY, tooltip)
		icon = icon and icon:gsub ("^gui/silkicons/(.*)%.vmt$", "icon16/%1.png")
		icon = icon and icon:gsub ("^gui/silkicons/(.*)$", "icon16/%1.png")
		return AddSheet (self, label, panel, icon, noStretchX, noStretchY, tooltip)
	end
	function panel:GetImage ()
		return GetImage (self):gsub ("^icon16/(.*)%.png$", "gui/silkicons/%1"), nil
	end
	function panel:GetItems ()
		if GetItems then return GetItems (self) end
		return self:GetChildren ()
	end
	function panel:GetSelected ()
		return self:IsSelected ()
	end
	function panel:SetImage (image)
		image = image:gsub ("^gui/silkicons/(.*)%.vmt$", "icon16/%1.png")
		image = image:gsub ("^gui/silkicons/(.*)$", "icon16/%1.png")
		return SetImage (self, image)
	end
	function panel:SetTextInset (x, y)
		return SetTextInset (self, x or 0, y or 0)
	end
	panel.SetType = function () end
end

function vgui.Create (className, ...)
	local panel = _G.vgui.Create (controlClassMap [className] or className, ...)
	LegacyCompat.VGUIPanels [panel] = true
	FixupPanel (panel, className)
	return panel
end

function vgui.CreateX (className, ...)
	local panel = _G.vgui.CreateX (controlClassMap [className] or className, ...)
	LegacyCompat.VGUIPanels [panel] = true
	FixupPanel (panel, className)
	return panel
end

function vgui.Register (className, metatable, baseClassName)
	_G.vgui.Register (className, metatable, controlClassMap [baseClassName] or baseClassName)
end