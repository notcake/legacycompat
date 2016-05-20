local G = {}
local R = {}
LegacyCompat.G = G
LegacyCompat.R = R
G._G = G
G._R = R

LegacyCompat.SetObjectWrapper (_G, G)

for k, v in pairs (_G) do
	if type (v) == "boolean" or
	   type (v) == "number" or
	   type (v) == "string" then
		G [k] = v
	end
end

for k, v in pairs (debug.getregistry ()) do
	R [k] = v
end

if SERVER then
	G.AddCSLuaFile = function () end
else
	G.AddCSLuaFile = function () end
end

function LegacyCompat.MetatableProxy ()
end

function LegacyCompat.MetatableProxyFunction ()
end

G.chat               = _G.chat
G.concommand         = _G.concommand
G.cvars              = _G.cvars
G.derma              = _G.derma
G.duplicator         = _G.duplicator
G.ents               = _G.ents
G.game               = _G.game
G.gmod               = _G.gmod
G.gui                = _G.gui
G.input              = _G.input
G.list               = _G.list
G.os                 = _G.os
G.render             = _G.render
G.resource           = _G.resource
G.scripted_ents      = _G.scripted_ents
G.string             = _G.string
G.table              = _G.table
G.team               = _G.team
G.umsg               = _G.umsg
G.weapons            = _G.weapons

G.GInterface         = _G.GInterface

G.Angle              = _G.Angle
G.Color              = _G.Color
G.Vector             = _G.Vector

G.ipairs             = _G.ipairs
G.next               = _G.next
G.pairs              = _G.pairs
G.pcall              = _G.pcall
G.print              = _G.print
G.tonumber           = _G.tonumber
G.tostring           = _G.tostring
G.type               = LegacyCompat.GetType
G.unpack             = _G.unpack

G.tobool             = _G.tobool

G.Error              = _G.Error
G.ErrorNoHalt        = _G.ErrorNoHalt

function G.PCallError (f, ...)
	return { xpcall (f, LegacyCompat.Error, ...) }
end

G.CurTime            = _G.CurTime
G.FrameTime          = _G.FrameTime
G.RealTime           = _G.RealTime
G.SysTime            = _G.SysTime

G.SinglePlayer       = _G.game.SinglePlayer

G.GetGlobalBool      = _G.GetGlobalBool
G.GetGlobalString    = _G.GetGlobalString
G.SetGlobalBool      = _G.SetGlobalBool
G.SetGlobalString    = _G.SetGlobalString

G.ScrH               = _G.ScrH
G.ScrW               = _G.ScrW

G.BroadcastLua       = _G.BroadcastLua
G.CreateClientConVar = _G.CreateClientConVar
G.CreateConVar       = _G.CreateConVar
G.GetConVar          = _G.GetConVar
G.GetConVarString    = _G.GetConVarString
G.GetHostName        = _G.GetHostName
G.LocalPlayer        = LegacyCompat.ProxyFunction (_G.LocalPlayer, "Player")
G.Material           = LegacyCompat.ProxyFunction (_G.Material,    "IMaterial")
G.Msg                = _G.Msg
G.MsgC               = _G.MsgC
G.MsgN               = _G.MsgN
G.RunConsoleCommand  = _G.RunConsoleCommand
G.ValidEntity        = _G.IsValid

G.CloseDermaMenus    = _G.CloseDermaMenus
G.PrintTable         = _G.PrintTable

function G.include (path)
	LegacyCompat.Include (path)
end

function G.require (path)
	if path == "datastream" then return end
	if path == "glon" then return end
	return require (path)
end

function G.FindMetaTable (name)
	return R [name]
end

LegacyCompat.NotFound = {}
setmetatable (G,
	{
		__index = function (self, name)
			if rawget (self, name) then return rawget (self, name) end
			LegacyCompat.NotFound [name] = true
		end
	}
)

LegacyCompat.IncludeDirectory ("legacycompat/env", true)