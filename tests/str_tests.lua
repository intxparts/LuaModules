package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local ut = require('utest')
local str = require('str')

ut:group('str.rep(s [string], n [int], sep [string]) -> [string]', function()

	ut:test('replicates the given [string] s, n times, separated by str', function()
		assert('hello,hello' == str.rep('hello', 2, ','))
	end)

	ut:test('nil args', function()
		local result, message = pcall(function() local s = str.rep() end)
		assert(result == false)
	end)

	ut:test('nil for string', function()
		local result, message = pcall(function() local s = str.rep(nil, 2) end)
		assert(result == false)
	end)

	ut:test('nil for replication count', function()
		local result, message = pcall(function() local s = str.rep('hello', nil) end)
		assert(result == false)
	end)

	ut:test('replicate single char string', function()
		assert('-----' == str.rep('-', 5))
	end)

	ut:test('replicate string with no separator', function()
		assert('hellohellohello' == str.rep('hello', 3))
	end)

	ut:test('replicate string with single char separator', function()
		assert('hello,hello' == str.rep('hello', 2, ','))
	end)

	ut:test('replicate string with multi-char separator', function()
		assert('hello | hello' == str.rep('hello', 2, ' | '))
	end)

	local data_set = { -3, -2, -1, 0, 1 }
	for _, v in ipairs(data_set) do
		ut:test(string.format('replicate string %d times', v), function()
			assert('hello' == str.rep('hello', v))
		end)
	end

	ut:test('str.rep(s, n, sep), s must be a string', function()
		local result, message = pcall(function() local my_str = str.rep(12, 2) end)
		assert(result == false)
	end)

	ut:test('str.rep(s, n, sep), n must be a number', function()
		local result, message = pcall(function() local my_str = str.rep('hello', '10') end)
		assert(result == false)
	end)

end)

ut:group('str.join(t [table], sep [string]) -> [string]', function()

	ut:test('nil table', function()
		local result, message = pcall(function() local s = str.join(nil) end)
		assert(result == false)
	end)

	ut:test('join single string', function()
		assert('hello, world!' == str.join({'hello, world!'}))
	end)

	ut:test('join single string with single-char separator', function()
		assert('hello, world!' == str.join({'hello, world!'}, ','))
	end)

	ut:test('join single string with multi-char separator', function()
		assert('hello, world!' == str.join({'hello, world!'}, ', '))
	end)

	ut:test('join multiple strings', function()
		assert('hello, world!' == str.join({'hello', ', ', 'world!'}))
	end)

	ut:test('join multiple strings with single-char separator', function()
		assert('hello, world!' == str.join({'hello', ' world!'}, ','))
	end)

	ut:test('join multiple strings with multi-char separator', function()
		assert('hello, world!' == str.join({'hello', 'world!'}, ', '))
	end)

	ut:test('join with nil in table', function()
		assert('hello' == str.join({[1]='hello',[2]=nil,[3]='world!'}))
	end)

	ut:test('join different types', function()
		local point = { __tostring = function() return '(0, 0)' end }
		local origin = setmetatable({}, point)

		assert('2D Cartesian Origin is (0, 0) is a true statement' == str.join({2, 'D Cartesian Origin is ', origin, ' is a ', true, ' statement'}))
	end)

	ut:test('join strings with numerical separator', function()
		assert('col10col20col3' == str.join({'col1', 'col2', 'col3'}, 0))
	end)

	ut:test('join strings with boolean separator', function()
		assert('col1truecol2truecol3' == str.join({'col1', 'col2', 'col3'}, true))
	end)

	ut:test('join strings with custom format separator', function()
		local format = { __tostring = function() return ' | ' end }
		local sep_format = setmetatable({}, format)

		assert('col1 | col2 | col3' == str.join({'col1', 'col2', 'col3'}, sep_format))
	end)

end)

ut:group('str.to_bool(s [string]) -> [nil, boolean]', function()

	ut:test('converts a [string] s to its boolean equivalent: str.to_bool("true") == true', function()
		assert(true == str.to_bool('true'))
	end)

	ut:test('str.to_bool(true) == nil', function()
		assert(nil == str.to_bool(v))
	end)

	ut:test('str.to_bool(0) == nil', function()
		assert(nil == str.to_bool(v))
	end)

	ut:test('str.to_bool({}) == nil', function()
		assert(nil == str.to_bool(v))
	end)

	ut:test('str.to_bool(nil) == nil', function()
		assert(nil == str.to_bool(nil))
	end)

	local invalid_strs = {'', ' ', 'True', 'False', 'random', '10', '.true'}
	for _, v in pairs(invalid_strs) do
		ut:test(string.format('str.to_bool("%s") == nil', v), function()
			assert(nil == str.to_bool(v))
		end)
	end

	ut:test('str.to_bool("false") == false', function()
		assert(false == str.to_bool('false'))
	end)
end)

ut:group('str.to_int(s [string]) -> [nil, int]', function()
	ut:test('str.to_int(true) == nil', function()
		assert(nil == str.to_int(v))
	end)

	ut:test('str.to_int({}) == nil', function()
		assert(nil == str.to_int(v))
	end)

	local invalid_strs = {'hello', '', ' ', '10%', '-.'}
	for _, v in pairs(invalid_strs) do
		ut:test(string.format('str.to_int("%s") == nil', v), function()
			assert(nil == str.to_int(v))
		end)
	end

	ut:test('str.to_int(-5.67) == -6', function()
		assert(-6 == str.to_int(-5.67))
	end)

	ut:test('str.to_int(1.79) == 1', function()
		assert(1 == str.to_int(1.79))
	end)

	ut:test('str.to_int("-5.67") == -6', function()
		assert(-6 == str.to_int("-5.67"))
	end)

	ut:test('str.to_int("1.79") == 1', function()
		assert(1 == str.to_int("1.79"))
	end)

end)

ut:group('str.first_index_of(s [string], e [any]) -> [int]', function()
	
	ut:test('s = nonstring', function()
		local success, err = pcall(function() str.first_index_of({'hello'},'hello') end)
		assert(not success)
	end)
	
	ut:test('s = empty string', function()
		local result = str.first_index_of('','')
		assert(result == -1)
	end)
	
	ut:test('s = length 1 string', function()
		local result = str.first_index_of('.', '.')
		assert(result == 1)
	end)
	
	ut:test('e -> length 0 string', function()
		local result = str.first_index_of('.', '')
		assert(result == -1)
	end)
	
	ut:test('first_index_of("C:\\Windows\\System32\\cmd.exe", "\\")', function()
		assert(str.first_index_of("C:\\Windows\\System32\\cmd.exe", "\\") == 3)
	end)
end)