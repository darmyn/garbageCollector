local garbageCollector = {}
garbageCollector.interface = {}
garbageCollector.schema = {}
garbageCollector.metatable = {__index = garbageCollector.schema}

function garbageCollector.interface.new()
	local self = setmetatable({}, garbageCollector.metatable)
	self._garbage = {}
	return self
end

function garbageCollector.schema.add(self: garbageCollector, garbage: {[number]: any})
	for _, g in pairs(garbage) do
		if g ~= nil then
			table.insert(self._garbage, g)
		end
	end 
end

function garbageCollector.schema.clean(self: garbageCollector)
	for _, garbage in pairs(self._garbage) do
		if typeof(garbage) == "function" then
			garbage()
		elseif typeof(garbage) == "RBXScriptConnection" then
			garbage:Disconnect()
		elseif typeof(garbage) == "table" then
			local destroyMethod = garbage.destroy
			if destroyMethod and typeof(destroyMethod) == "function" then
				garbage:destroy()
			end
		elseif typeof(garbage) == "Instance" then
			garbage:Destroy()
		end
	end
	table.clear(self._garbage)
end

type garbageCollector = typeof(garbageCollector.interface.new())

return garbageCollector.interface