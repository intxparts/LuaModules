local array = {}
array.__index = array

function array:length()
	return self._len
end

function array.new()
	local a = {_len=0}
	setmetatable(a, array)
	return a
end

function array:insert(e)
	self._len = self._len + 1
	self[self._len] = e
end

function array:insert_at(e, i)
	assert(1 <= i and i <= self._len, 'index out of range')
	for j = self._len, i, -1 do
		self[j+1] = self[j]
	end
	self[i] = e
	self._len = self._len + 1
end

function array:insert_range(idx, arr)
	assert(1 <= idx and idx <= self._len)
	local count = #arr
	for j = idx, self._len do
		local new_idx = idx + count
		self[new_idx] = self[j]
	end

	for j = 1, count do
		local new_idx = idx + j - 1
		self[new_idx] = arr[j]
	end
	self._len = self._len + count
end

function array:contains(e)
	for j = 1, self._len do
		if self[j] == e then
			return true
		end
	end
	return false
end

function array:index_of(e, start_idx, end_idx)
	local s_idx = start_idx or 1
	local e_idx = end_idx or self._len
	assert(1 <= s_idx and s_idx <= e_idx)
	assert(s_idx <= e_idx and e_idx <= self._len)

	for j = s_idx, e_idx do
		if self[j] == e then
			return j
		end
	end
	return -1
end

function array:last_index_of(e, start_idx, end_idx)
	local s_idx = start_idx or 1
	local e_idx = end_idx or self._len
	assert(1 <= s_idx and s_idx <= e_idx)
	assert(s_idx <= e_idx and e_idx <= self._len)

	for j = e_idx, s_idx, -1 do
		if self[j] == e then
			return j
		end
	end
	return -1
end

function array:clone()
	local a = array.new()
	for j = 1, self._len do
		a[j] = self[j]
	end
	a._len = self._len
	return a
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
	if found then
		self._len = self._len - 1
	end
end

-- remove_range

function array:clear()
	for j = 1, self._len do
		self[j] = nil
	end
	self._len = 0
end

function array:reverse()
	local half_len = self._len / 2
	for j = 1, half_len do
		local swap_idx = self._len + 1 - j
		local tmp = self[j]
		self[j] = self[swap_idx]
		self[swap_idx] = tmp
	end
end

return array
