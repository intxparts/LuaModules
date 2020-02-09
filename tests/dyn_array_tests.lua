package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local ut = require('utest')
local dyn_array = require('dyn_array')

ut:group('dyn_array.new() -> [dyn_array]', function()
	ut:test('initializes an empty dyn_array with _len == 0', function()
		local a = dyn_array.new()
		assert(a._len == 0)
		local result, err = pcall(function() return a[1] end)
		assert(not result)
	end)
end)

ut:group('dyn_array:insert(e [any]) ->', function()
	ut:test('inserts an element e to the end of the dyn_array and increments _len by 1', function()
		local a = dyn_array.new()
		a:insert(1)
		a:insert(3)
		assert(a[1] == 1 and a[2] == 3)
		assert(a._len == 2)
	end)

	ut:test('no arg inserts nil', function()
		local a = dyn_array.new()
		a:insert()
		assert(a._len == 1)
		assert(a[1] == nil)
	end)

	ut:test('nil arg inserts nil', function()
		local a = dyn_array.new()
		a:insert(nil)
		assert(a._len == 1)
		assert(a[1] == nil)
	end)

	ut:test('insert table element', function()
		local a = dyn_array.new()
		local e = {age=22, name='john doe'}
		a:insert(e)
		assert(a[1] == e)
		assert(a._len == 1)
	end)

	ut:test('multiple inserts', function()
		local a = dyn_array.new()
		for i=1, 100 do
			a:insert(i)
		end
		for i=1, 100 do
			assert(a[i] == i)
		end
		assert(a._len == 100)
	end)

end)

ut:group('dyn_array:insert_at(e [any], i [int]) ->', function()
	ut:test('inserts an element e at index i in the dyn_array and increases _len by 1', function()
		local a = dyn_array.new()
		a:insert(4)
		a:insert(1)
		a:insert_at(2, 2)
		assert(a[1] == 4 and a[2] == 2 and a[3] == 1)
		assert(a._len == 3)
	end)

	ut:test('no args raises error', function()
		local a = dyn_array.new()
		local success, err = pcall(function() a:insert_at() end)
		assert(not success)
	end)

	ut:test('single arg raises error', function()
		local a = dyn_array.new()
		local success, err = pcall(function() a:insert_at(1) end)
		assert(not success)
	end)

	ut:test('non-number idx raises error', function()
		local a = dyn_array.new()
		local success, err = pcall(function() a:insert_at({}) end)
		assert(not success)
	end)

	ut:test('0 idx raises index out of range error', function()
		local a = dyn_array.new()
		a:insert(-1.2)
		local success, err = pcall(function() a:insert_at(2.3, 0) end)
		assert(not success and err:find('index out of bounds') ~= nil)
	end)

	ut:test('inst._len + 1 idx raises index out of range error', function()
		local a = dyn_array.new()
		a:insert({name='john'})
		local idx = a._len + 1
		local success, err = pcall(function() a:insert_at({name='jane'}, idx) end)
		assert(not success and err:find('index out of bounds') ~= nil)
	end)

end)

ut:group('dyn_array:length() -> [int]', function()
	ut:test('returns the number of elements in the dyn_array, tracked by inst._len', function()
		local a = dyn_array.new()
		a:insert(1)
		a:insert(2)
		assert(a._len == 2)
		assert(a:length() == 2)
	end)

	ut:test('empty dyn_array returns 0', function()
		local a = dyn_array.new()
		assert(a._len == 0)
		assert(a:length() == 0)
	end)

	ut:test('changes to a._len are observed', function()
		local a = dyn_array.new()
		a._len = 10
		assert(a:length() == 10)
	end)

end)

ut:group('dyn_array:clear() ->', function()
	ut:test('removes all elements and sets inst._len = 0', function()
		local a = dyn_array.new()
		a:insert(1)
		a:insert(2)
		a:insert(3)
		assert(a._len == 3)
		a:clear()
		assert(a._len == 0)
		local result, err = pcall(function() return a[1] end)
		assert(not result)
	end)
end)

ut:group('dyn_array:remove(e [any]) ->', function()
	ut:test('removes the target element [number] and reduces inst._len by 1', function()
		local a = dyn_array.new()
		a:insert(1)
		a:insert(2)
		assert(a._len == 2)
		a:remove(2)
		assert(a._len == 1 and a[1] == 1)
	end)

	ut:test('removes the target element [string] and reduces inst._len by 1', function()
		local a = dyn_array.new()
		a:insert('hello')
		a:insert('world')
		assert(a._len == 2)
		a:remove('world')
		assert(a._len == 1 and a[1] == 'hello')
	end)

	ut:test('removes the target element [table] and reduces inst._len by 1', function()
		local a = dyn_array.new()
		local pt1 = {x=0}
		local pt2 = {x=2}
		a:insert(pt1)
		a:insert(pt2)
		assert(a._len == 2)
		a:remove(pt1)
		assert(a._len == 1 and a[1] == pt2)
	end)

	ut:test('removes the target element [boolean] and reduces inst._len by 1', function()
		local a = dyn_array.new()
		a:insert(true)
		a:insert(false)
		assert(a._len == 2)
		a:remove(false)
		assert(a._len == 1 and a[1] == true)
	end)

	ut:test('removes the first element [number] found in dyn_array when there are multiple', function()
		local a = dyn_array.new()
		a:insert(1)
		a:insert(2)
		a:insert(1)
		assert(a._len == 3)
		a:remove(1)
		assert(a._len == 2 and a[1] == 2 and a[2] == 1)
	end)

	ut:test('removes the first element [table] found in dyn_array when there are multiple', function()
		local a = dyn_array.new()
		local pt1 = { x=0, y=0 }
		local pt2 = { x=1, y=0 }
		a:insert(pt1)
		a:insert(pt2)
		a:insert(pt1)
		assert(a._len == 3)
		a:remove(pt1)
		assert(a._len == 2 and a[1] == pt2 and a[2] == pt1)
	end)

	ut:test('removes the first element [string] found in dyn_array when there are multiple', function()
		local a = dyn_array.new()
		a:insert('hello')
		a:insert('world')
		a:insert('hello')

		assert(a._len == 3)
		a:remove('hello')
		assert(a._len == 2 and a[1] == 'world' and a[2] == 'hello')
	end)

	ut:test('removes the first element [boolean] found in dyn_array when there are multiple', function()
		local a = dyn_array.new()
		a:insert(true)
		a:insert(false)
		a:insert(true)

		assert(a._len == 3)
		a:remove(false)
		assert(a._len == 2 and a[1] == true and a[2] == true)
	end)

	ut:test('does nothing when target element [int] is not in the dyn_array', function()
		local a = dyn_array.new()
		a:insert(1)
		a:insert(2)

		a:remove(3)
		assert(a._len == 2 and a[1] == 1 and a[2] == 2)
	end)

	ut:test('does nothing when target element [table] is not in the dyn_array', function()
		local a = dyn_array.new()
		local pt1 = {x=0}
		local pt2 = {x=1}
		a:insert(pt1)
		a:insert(pt2)

		a:remove({x=0})
		assert(a._len == 2 and a[1] == pt1 and a[2] == pt2)
	end)

end)

ut:group('dyn_array:index_of(e [any], start_idx [int], end_idx [int]) -> [int]', function()
	local a = dyn_array.new({ 10, 2, -34, -133, 2, 7})
	
	ut:test('returns the first found index of the target element in the dyn_array', function()
		assert(a:index_of(2, 1, 6) == 2)
	end)

	ut:test('returns the index of the target element in the dyn_array within the specified bounds', function()
		assert(a:index_of(-34, 3, 4) == 3)
	end)

	ut:test('start_idx defaults to the first element index when not provided', function()
		assert(a:index_of(10) == 1)
	end)

	ut:test('end_idx defaults to the last element index when not provided', function()
		assert(a:index_of(7, 1) == 6)
	end)

	ut:test('returns -1 when the target element is not in the dyn_array', function()
		assert(a:index_of(65) == -1)
	end)

	ut:test('raises an error for start_idx = 0; index out of bounds', function()
		local result, err = pcall(function() return a:index_of(10, 0, 2) end)
		assert(not result and err:find('index out of bounds') ~= nil)
	end)

	ut:test('raises an error for start_idx = -1; index out of bounds', function()
		local result, err = pcall(function() return a:index_of(10, -1, 2) end)
		assert(not result and err:find('index out of bounds') ~= nil)
	end)

	ut:test('raises an error for start_idx > end_idx; index out of bounds', function()
		local result, err = pcall(function() return a:index_of(10, 2, 1) end)
		assert(not result and err:find('index out of bounds') ~= nil)
	end)

	ut:test('raises an error for end_idx > a._len; index out of bounds', function()
		local result, err = pcall(function() return a:index_of(10, 1, 10) end)
		assert(not result and err:find('index out of bounds') ~= nil)
	end)

end)

ut:group('dyn_array:contains(e [any]) -> [bool]', function()
	local a = dyn_array.new({ 1, -2, 13 })
	ut:test('returns true if target element is found', function()
		assert(a:contains(-2) == true)
	end)

	ut:test('returns false if target element is not found', function()
		assert(a:contains(65) == false)
	end)
end)

ut:group('dyn_array:insert_range_at(arr [table], idx [int]) ->', function()
	ut:test('inserts dyn_array into target dyn_array at index idx', function()
		local a = dyn_array.new({ 23, -1, 2 })
		a:insert_range_at(dyn_array.new({2, 3, 4, 7}), 2)
		assert(
			a._len == 7 and
			a[1] == 23 and 
			a[2] == 2 and 
			a[3] == 3 and 
			a[4] == 4 and 
			a[5] == 7 and
			a[6] == -1 and
			a[7] == 2
		)
	end)
end)

ut:group('dyn_array:remove_at(idx [int]) ->', function()
	ut:test('removes the element at the given index and moves all elements after forwards', function()
		local a = dyn_array.new({'hello', 'aloha', 'goodbye'})
		a:remove_at(2)
		assert(a._len == 2 and a[1] == 'hello' and a[2] == 'goodbye')
	end)
end)

ut:group('dyn_array:remove_range_at(start_idx [int], remove_count [int]) ->', function()
	ut:test('removes remove_count elements starting at start_idx', function()
		local a = dyn_array.new({'abc', 'xyz', 'rst', 'bs'})
		a:remove_range_at(2, 3)
		assert(a._len == 1 and a[1] == 'abc')
	end)
end)

ut:group('dyn_array:reverse() ->', function()
	ut:test('reverses the dyn_array', function()
		local a = dyn_array.new({'abc', 'xyz', 'rst'})
		a:reverse()
		assert(a._len == 3 and a[1] == 'rst' and a[2] == 'xyz' and a[3] == 'abc')
	end)
end)

ut:group('dyn_array:last_index_of(e [any], start_idx [int], end_idx [int]) -> [int]', function()
	ut:test('returns the last index of the target element between the given indices', function()
		local a = dyn_array.new({24, -2, 13, 5, 9, 5})
		local start_idx = 1
		local end_idx = 6
		assert(a:last_index_of(5, start_idx, end_idx) == end_idx)
	end)
end)

ut:group('dyn_array.__index(t [table], k [any]) -> [any]', function()
	ut:test('returns the value stored at index k [int]', function()
		local a = dyn_array.new()
		a:insert('hello')
		a:insert('aloha')
		a:insert('goodbye')

		assert(a[1] == 'hello' and a[2] == 'aloha' and a[3] == 'goodbye')
	end)

	ut:test('raises an error for index k, k == 0; index out of bounds', function()
		local a = dyn_array.new()
		a:insert(1)
		local result, err = pcall(function() return a[0] end)
		assert(not result and err:find('index out of bounds') ~= nil)
	end)

	ut:test('raises an error for index k, k < 0; index out of bounds', function()
		local a = dyn_array.new()
		a:insert(1)
		local result, err = pcall(function() return a[-1] end)
		assert(not result and err:find('index out of bounds') ~= nil)
	end)

	ut:test('raises an error for index k, k > inst._len; index out of bounds', function()
		local a = dyn_array.new()
		a:insert(2)
		local result, err = pcall(function() return a[a._len + 1] end)
		assert(not result and err:find('index out of bounds') ~= nil)
	end)
end)

ut:group('dyn_array.__newindex(t [table], k [any], v [any]) ->', function()
	ut:test('raises an error for attempting to add properties onto the dyn_array', function()
		local a = dyn_array.new()
		local result, err = pcall(function() a.greet = 'hello' end)
		assert(not result)
	end)

	ut:test('raises an error for attempting to add an element at 0 index', function()
		local a = dyn_array.new()
		local result, err = pcall(function() a[0] = 2 end)
		assert(not result)
	end)

	ut:test('raises an error for attempting to add an element at -1 index', function()
		local a = dyn_array.new()
		local result, err = pcall(function() a[-1] = 2 end)
		assert(not result)
	end)

end)

ut:group('lua standard library compatibility ->', function()
	ut:test('# can be used to determine the length', function()
		local a = dyn_array.new()
		assert(#a == 0)
		assert(a._len == 0)
		a:insert(1)
		a:insert(2)
		assert(#a == 2)
		assert(a._len == 2)
	end)
end)

if _VERSION == 'Lua 5.3' then
ut:group('Lua 5.3 ->', function()
	ut:test('unable to iterate with ipairs, since ipairs indexes tables regardless of out of bounds', function()
		local a = dyn_array.new()
		a:insert(1)
		a:insert(2)
		local result, err = pcall(function() for i, v in ipairs(a) do local t = v end end)
		assert(not result)
	end)
end)
elseif _VERSION == 'Lua 5.1' then
ut:group('Lua 5.1 (Luajit) ->', function()
	ut:test('is able to iterate with ipairs', function()
		local a = dyn_array.new()
		a:insert(1)
		a:insert(2)
		for i, v in ipairs(a) do
			a[i] = v + 1
		end
		assert(a[1] == 2 and a[2] == 3)
	end)
end)
end


