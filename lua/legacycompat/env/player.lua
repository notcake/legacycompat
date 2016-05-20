local player = {}
LegacyCompat.G.player = player

player.GetAll        = LegacyCompat.ProxyArrayFunction (_G.player.GetAll,        "Player")
player.GetByID       = LegacyCompat.ProxyFunction      (_G.player.GetByID,       "Player")
player.GetByUniqueID = LegacyCompat.ProxyFunction      (_G.player.GetByUniqueID, "Player")
player.GetBots       = LegacyCompat.ProxyArrayFunction (_G.player.GetBots,       "Player")
player.GetHumans     = LegacyCompat.ProxyArrayFunction (_G.player.GetHumans,     "Player")