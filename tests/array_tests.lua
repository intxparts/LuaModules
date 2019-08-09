package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local tl = require('test_lab')
local array = require('array')

tl:group('array.new() ->', function()
	tl:test('initializes an empty array with _len == 0', function()
		local a = array.new()
		assert(a._len == 0)
		local num_elements = 0
		for i, v in ipairs(a) do
			num_elements = num_elements + 1
		end
		assert(num_elements == 0)
	end)

end)

tl:group('array:insert(e [any]) ->', function()

	tl:test('inserts an element e to the end of the array and increments _len by 1', function()
		local a = array.new()
		a:insert(1)
		a:insert(3)
		assert(a[1] == 1 and a[2] == 3)
		assert(a._len == 2)
	end)

	tl:test('no arg inserts nil', function()
		local a = array.new()
		a:insert()
		assert(a._len == 1)
		assert(a[1] == nil)
	end)

	tl:test('nil arg inserts nil', function()
		local a = array.new()
		a:insert(nil)
		assert(a._len == 1)
		assert(a[1] == nil)
	end)

	tl:test('insert table element', function()
		local a = array.new()
		local e = {age=22, name='john doe'}
		a:insert(e)
		assert(a[1] == e)
		assert(a._len == 1)
	end)

	tl:test('multiple inserts', function()
		local a = array.new()
		for i=1, 100 do
			a:insert(i)
		end
		for i=1, 100 do
			assert(a[i] == i)
		end
		assert(a._len == 100)
	end)

end)

tl:group('array:insert_at(e [any], i [int]) ->', function()
	tl:test('inserts an element e at index i in the array and increases _len by 1', function()
		local a = array.new()
		a:insert(4)
		a:insert(1)
		a:insert_at(2, 2)
		assert(a[1] == 4 and a[2] == 2 and a[3] == 1)
		assert(a._len == 3)
	end)

	tl:test('no args raises error', function()
		local a = array.new()
		local success, err = pcall(function() a:insert_at() end)
		assert(not success)
	end)

	tl:test('single arg raises error', function()
		local a = array.new()
		local success, err = pcall(function() a:insert_at(1) end)
		assert(not success)
	end)

	tl:test('non-number idx raises error', function()
		local a = array.new()
		local success, err = pcall(function() a:insert_at({}) end)
		assert(not success)
	end)

	tl:test('0 idx raises index out of range error', function()
		local a = array.new()
		a:insert(-1.2)
		local success, err = pcall(function() a:insert_at(2.3, 0) end)
		assert(not success and err:find('index out of range') ~= nil)
	end)

	tl:test('inst._len + 1 idx raises index out of range error', function()
		local a = array.new()
		a:insert({name='john'})
		local idx = a._len + 1
		local success, err = pcall(function() a:insert_at({name='jane'}, idx) end)
		assert(not success and err:find('index out of range') ~= nil)
	end)

end)

tl:group('array:length() ->', function()
	tl:test('returns the number of elements in the array, tracked by inst._len', function()
		local a = array.new()
		a:insert(1)
		a:insert(2)
		assert(a._len == 2)
		assert(a:length() == 2)
	end)

	tl:test('empty array returns 0', function()
		local a = array.new()
		assert(a._len == 0)
		assert(a:length() == 0)
	end)

	tl:test('changes to a._len are observed', function()
		local a = array.new()
		a._len = 10
		assert(a:length() == 10)
	end)

end)

tl:group('array:clear() ->', function()
	tl:test('removes all elements and sets inst._len = 0', function()
		local a = array.new()
		a:insert(1)
		a:insert(2)
		a:insert(3)
		assert(a._len == 3)
		a:clear()
		assert(a[1] == nil and a[2] == nil and a[3] == nil and a._len == 0)
	end)
end)
