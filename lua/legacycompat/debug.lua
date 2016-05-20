LegacyCompat.FunctionInfo     = LegacyCompat.WeakKeyTable ()
LegacyCompat.FunctionMetadata = LegacyCompat.WeakKeyTable ()
LegacyCompat.FunctionUpvalues = LegacyCompat.WeakKeyTable ()
LegacyCompat.WrappedFunctions = LegacyCompat.WeakTable ()

function LegacyCompat.GetFunctionInfo (f)
	return LegacyCompat.FunctionInfo [f] or debug.getinfo (f)
end

function LegacyCompat.GetFunctionUpvalues (f)
	return LegacyCompat.FunctionUpvalues [f]
end

function LegacyCompat.GetWrappedFunction (f)
	return LegacyCompat.WrappedFunctions [f]
end

function LegacyCompat.SetFunctionInfo (f, info)
	LegacyCompat.FunctionInfo [f] = info
end

function LegacyCompat.SetFunctionUpvalues (f, upvalues)
	LegacyCompat.FunctionUpvalues [f] = upvalues
end

function LegacyCompat.SetWrappedFunction (f, wrappedFunction)
	LegacyCompat.WrappedFunctions [f] = wrappedFunction
end