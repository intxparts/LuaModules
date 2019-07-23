local array = {}
array.__index = array

function array.__len(o)
	return o._len
end

function array.new()
	local a = {_len=0}
	setmetatable(a, array)
	return a
end

function array:append(e)
	self._len = self._len + 1
	self[self._len] = e
end

function array:insert_at(e, i)
	assert(1 <= i and i <= self._len)
	for j = self._len, i, -1 do
		self[j+1] = self[j]
	end
	self[i] = e
	self._len = self._len + 1
end

function array:index_of(e)
	for j = 1, self._len do
		if self[j] == e then
			return j
		end
	end
	return -1
end

function array:remove_at(i)
	assert(1 <= i and i <= self._len)
	for j = i, self._len do
		self[j] = self[j+1]	
	end
	self._len = self._len - 1
end

function array:remove(e)
	local found = false
	for j = 1, self._len do
		if not found and self[j] == e then
			found = true
		end

		if found then
			self[j] = self[j+1]
		end
	end
end


return array
