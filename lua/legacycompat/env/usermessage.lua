local usermessage = {}
LegacyCompat.G.usermessage = usermessage
LegacyCompat.UsermessageHandlers = {}

function usermessage.GetTable ()
	return LegacyCompat.UsermessageHandlers
end

function usermessage.Hook (messageId, handler, ...)
	LegacyCompat.UsermessageHandlers [messageId] =
	{
		Function = handler,
		PreArgs  = {...}
	}
	
	_G.usermessage.Hook (messageId,
		function (umsg)
			usermessage.IncomingMessage (messageId, umsg)
		end
	)
end

LegacyCompat.SetFunctionUpvalues (usermessage.Hook,
	{
		{ "Hooks", LegacyCompat.UsermessageHandlers }
	}
)

function usermessage.IncomingMessage (messageId, umsg)
	local handlerEntry = LegacyCompat.UsermessageHandlers [messageId]
	handlerEntry.Function (umsg, unpack (handlerEntry.PreArgs))
end