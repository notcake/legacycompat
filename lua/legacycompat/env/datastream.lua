local datastream = {}LegacyCompat.G.datastream = datastreamif SERVER then	util.AddNetworkString ("LegacyCompat.Datastream")endlocal handlers = {}function datastream.Hook (streamId, handler)	handlers [streamId] = handlerendif SERVER then	function datastream.StreamToClients (clients, streamId, data)		net.Start ("LegacyCompat.Datastream")			net.WriteString (streamId)			net.WriteTable (data)		net.Send (clients)	endendif CLIENT then	function datastream.StreamToServer (clients, streamId, data)		net.Start ("LegacyCompat.Datastream")			net.WriteString (streamId)			net.WriteTable (data)		net.SendToServer ()	endend