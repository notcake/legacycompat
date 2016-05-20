local IMaterial = {}
LegacyCompat.R.IMaterial = IMaterial

local types =
{
	"Float",
	"Int",
	"Matrix",
	"String",
	"Texture",
	"Vector"
}

for _, typeName in ipairs (types) do
	IMaterial ["GetMaterial" .. typeName] = function (self, ...)
		return self ["Get" .. typeName] (self, ...)
	end
	IMaterial ["SetMaterial" .. typeName] = function (self, ...)
		return self ["Set" .. typeName] (self, ...)
	end
end

function IMaterial:__tostring ()
	return tostring (self)
end