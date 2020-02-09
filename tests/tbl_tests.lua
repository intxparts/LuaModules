package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local ut = require('utest')
local tbl = require('tbl')

ut:group('tbl.count(t [table], fn [function]) -> [number]', function()
	ut:test('empty table, no filter function', function()
		assert(0 == tbl.count({}))
	end)

	ut:test('empty table, with filter function', function()
		assert(0 == tbl.count({}, function(k, v) return k % 2 ~= 0 end))
	end)

	ut:test('array table, no filter function', function()
		assert(3 == tbl.count({ 1, 2, 3 }))
	end)

	ut:test('array table, with filter function, match subset elements', function()
		assert(1 == tbl.count({ 1, 2, 3 }, function(k, v) return v % 2 == 0 end))
	end)

	ut:test('array table, with filter function, match all elements', function()
		assert(3 == tbl.count({ 2, 4, 6 }, function(k, v) return v % 2 == 0 end))
	end)

	ut:test('array table, with filter function, match no elements', function()
		assert(0 == tbl.count({ 1, 2, 3 }, function(k, v) return v % 4 == 0 end))
	end)

	ut:test('holey table, no filter function', function()
		assert(5 == tbl.count({ [1]=2, [2]=3, [3]=5, [5]=7, [7]=11 }))
	end)

	ut:test('holey table, with filter function, match subset elements', function()
		assert(4 == tbl.count({ [1]=2, [2]=3, [3]=5, [5]=7, [7]=11 }, function(k, v) return k % 2 ~= 0 end))
	end)

	ut:test('holey table, with filter function, match all elements', function()
		assert(5 == tbl.count({ [1]=2, [2]=3, [3]=5, [5]=7, [7]=11 }, function(k, v) return v % 1 == 0 end))
	end)

	ut:test('holey table, with filter function, match no elements', function()
		assert(0 == tbl.count({ [1]=2, [2]=3, [3]=5, [5]=7, [7]=11 }, function(k, v) return v % 4 == 0 end))
	end)

	ut:test('dictionary table, no filter function', function()
		assert(2 == tbl.count({greeting='hello', farewell='goodbye'}))
	end)

	ut:test("dictionary table, with filter function, match all elements", function()
		assert(2 == tbl.count({greeting='hello', farewell='goodbye'}, function(k, v) return string.find(v, 'o') ~= nil end))
	end)

	ut:test("dictionary table, with filter function, match no elements", function()
		assert(0 == tbl.count({greeting='hello', farewell='goodbye'}, function(k, v) return string.find(v, 't') ~= nil end))
	end)

	ut:test("dictionary table, with filter function, match subset elements", function()
		assert(1 == tbl.count({greeting='hello', farewell='goodbye'}, function(k, v) return string.find(v, 'y') ~= nil end))
	end)

end)

ut:group('tbl.apply(t [table], fn [function]) -> [table]', function()

	ut:test('no args', function()
		local success, err = pcall(function() tbl.apply() end)
		assert(not success)
	end)

	ut:test('arg[0] must be a table', function()
		local success, err = pcall(function() tbl.apply(0, function() print('hello') end) end)
		assert(not success)
	end)

	ut:test('arg[1] must be defined for non-empty tables', function()
		local success, err = pcall(function() tbl.apply({1}) end)
		assert(not success)
	end)

	ut:test('arg[1] must be callable', function()
		local success, err = pcall(function() tbl.apply({1}, 0) end)
		assert(not success)
	end)

	ut:test('arg[1] as callable object', function()
		local modifier = {}
		local mt = {}
		mt.__index = mt
		mt.__call = function(fn, ...)
			for _, v in pairs({...}) do
				return v + 1
			end
		end
		setmetatable(modifier, mt)
		local result = tbl.apply({1, 2}, modifier)
		assert(result[1] == 2 and result[2] == 3)
	end)

	ut:test('original table is modified and returned', function()
		local orig = {1,2}
		local result = tbl.apply(orig, function(v) return v+1 end)
		assert(orig == result)
		assert(result[1] == 2 and result[2] == 3)
	end)

	ut:test('empty table', function()
		local success, err = pcall(function() tbl.apply({}, function(v) return v end) end)
		assert(success)
	end)

	ut:test('empty table with missing arg[1] does nothing', function()
		local success, err = pcall(function() tbl.apply({}) end)
		assert(success)
	end)

end)

ut:group('tbl.clone(t [table]) -> [table]', function()

	ut:test('empty table', function()
		local initial_table = {}
		local clone = tbl.clone(initial_table)
		assert(initial_table ~= clone)
		assert(tbl.deep_equal(initial_table, clone))
	end)

	ut:test('array table', function()
		local initial_table = { 1, 2, 3, 4, 5, 6, 7, 8 }
		local clone = tbl.clone(initial_table)
		assert(initial_table ~= clone)
		assert(tbl.deep_equal(initial_table, clone))
	end)

	ut:test('dictionary table', function()
		local initial_table = { greeting="hello", farewell="goodbye" }
		local clone = tbl.clone(initial_table)
		assert(initial_table ~= clone)
		assert(tbl.deep_equal(initial_table, clone))
	end)

	ut:test('holey table', function()
		local initial_table = { [1]=1, [3]=2, [5]=3, [6]=4, [7]=5, [8]=6, [10]=7, [12]=8 }
		local clone = tbl.clone(initial_table)
		assert(initial_table ~= clone)
		assert(tbl.deep_equal(initial_table, clone))
	end)

	ut:test('table with subtable', function()
		local initial_table = { greeting='hello', data={ 1, 2, 3, 5, 7 }}
		local clone = tbl.clone(initial_table)
		assert(initial_table ~= clone)
		assert(tbl.deep_equal(initial_table, clone))
	end)
end)

ut:group('tbl.deep_equal(t1 [table], t2 [table]) -> [bool]', function()
	ut:test('empty tables - equal', function()
		assert(tbl.deep_equal({}, {}))
	end)

	ut:test('array table - equal', function()
		assert(tbl.deep_equal({1, 2, 3}, {1, 2, 3}))
	end)

	ut:test('dictionary table - equal', function()
		assert(tbl.deep_equal({ greeting="hello", counter=16 }, { greeting="hello", counter=16 }))
	end)

	ut:test('dictionary table - keys different - not equal', function()
		greet_fn = function() print('hello') end
		local lhs = {
			greet = greet_fn,
			data = { 2, 3, 4 },
			str_data = 'str_data',
			bool_data = false,
			num_data = -1
		}
		local rhs = {
			disengage = function() print('goodbye') end,
			greet = greet_fn,
			data = { 2, 3, 4 },
			str_data = 'str_data',
			bool_data = false,
			num_data = -1
		}
		assert(not tbl.deep_equal(lhs, rhs))
	end)

	ut:test('dictionary table - keys different in subtable - not equal', function()
		greet_fn = function() print('hello') end
		local lhs = {
			greet = greet_fn,
			data = { greeting='hello', farewell='goodbye' },
			str_data = 'str_data',
			bool_data = false,
			num_data = -1
		}
		local rhs = {
			disengage = function() print('goodbye') end,
			greet = greet_fn,
			data = { greeting='hello' },
			str_data = 'str_data',
			bool_data = false,
			num_data = -1
		}
		assert(not tbl.deep_equal(lhs, rhs))
	end)

	ut:test('dictionary table - values different - not equal', function()
		greet_fn = function() print('hello') end
		local lhs = {
			greet = greet_fn,
			data = { 2, 3, 4 },
			str_data = 'str_data',
			bool_data = false,
			num_data = -1
		}
		local rhs = {
			greet = greet_fn,
			data = { 2, 3, 4 },
			str_data = 'str_data',
			bool_data = false,
			num_data = 1
		}
		assert(not tbl.deep_equal(lhs, rhs))
	end)

	ut:test('dictionary table - values different in subtable - not equal', function()
		greet_fn = function() print('hello') end
		local lhs = {
			greet = greet_fn,
			data = { 2, 3, 5 },
			str_data = 'str_data',
			bool_data = false,
			num_data = -1
		}
		local rhs = {
			greet = greet_fn,
			data = { 2, 3, 4 },
			str_data = 'str_data',
			bool_data = false,
			num_data = -1
		}
		assert(not tbl.deep_equal(lhs, rhs))
	end)

	ut:test('table with subtables - equal', function()
		greet_fn = function() print('hello') end
		local lhs = {
			6,
			true,
			'goodbye',
			alpha = {1, 2, false},
			beta = {3, 2, 'str'},
			[100]=nil,
			greet=greet_fn
		}
		local rhs = {
			6,
			true,
			'goodbye',
			alpha = {1, 2, false},
			beta = {3, 2, 'str'},
			[100]=nil,
			greet=greet_fn
		}
		assert(tbl.deep_equal(lhs, rhs))
	end)

	ut:test('table with subtables - number within subtable - not equal', function()
		assert(not tbl.deep_equal({{1, 2}}, {{1, 3}}))
	end)

	ut:test('table with subtables - string within subtable - not equal', function()
		assert(not tbl.deep_equal({{1, greeting='hello'}}, {{1, greeting='HELLO'}}))
	end)

	ut:test('table with subtables - bool within subtable - not equal', function()
		assert(not tbl.deep_equal({{1, bool=true}}, {{1, bool=false}}))
	end)
end)

ut:group('tbl.filter(t [table], fn [function]) -> [table]', function()
	ut:test('no args', function()
		local success, err = pcall(function() tbl.filter() end)
		assert(not success)
	end)

	ut:test('no filter function provided', function()
		local success, err = pcall(function() tbl.filter({1, 2}) end)
		assert(not success)
	end)

	ut:test('filter table based on key', function()
		local t = {1, 2, 3, 4, 5}
		assert(tbl.deep_equal(tbl.filter(t, function(k, v) return k % 2 == 0 end), {2, 4}))
	end)

	ut:test('filter table based on values - match subset of table', function()
		local t = {1, 2, 3, 4, 5}
		local actual = tbl.filter(t, function(k, v) return v % 3 == 0 end)
		local expected = {3}
		assert(actual ~= expected)
		assert(tbl.deep_equal(actual, expected))
	end)

	ut:test('filter table based on values - match all elements', function()
		local t = {1, 2, 3, 4, 5}
		assert(tbl.deep_equal(tbl.filter(t, function(k, v) return v % 1 == 0 end), t))
	end)

end)

ut:group('tbl.contains_value(t [table], value [any]) -> [bool]', function()

	ut:test('no args', function()
		local success, err = pcall(function() tbl.contains_value() end)
		assert(not success)
	end)

	ut:test('table contains value: function', function()
		local id_fn = function(v) return v end
		local t = { fn=id_fn }
		assert(tbl.contains_value(t, id_fn))
	end)

	ut:test('table contains value: bool', function()
		local my_bool = false
		local t = { a_bool = my_bool }
		assert(tbl.contains_value(t, my_bool))
	end)

	ut:test('table contains value: number', function()
		local my_num = 3.14
		local t = { a_num = my_num }
		assert(tbl.contains_value(t, my_num))
	end)

	ut:test('table contains value: string', function()
		local my_str = 'my_str'
		local t = { a_str = my_str }
		assert(tbl.contains_value(t, my_str))
	end)

	ut:test('table contains value: table', function()
		local my_tbl = {1, 2, 3}
		local t = { a_tbl = my_tbl }
		assert(tbl.contains_value(t, my_tbl))
	end)

	ut:test('table does not contain value: function', function()
		local id_fn = function(v) return v end
		local t = { fn=function(v) return v end }
		assert(not tbl.contains_value(t, id_fn))
	end)

	ut:test('table does not contain value: bool', function()
		local my_bool = false
		local t = { a_bool = true }
		assert(not tbl.contains_value(t, my_bool))
	end)

	ut:test('table does not contain value: number', function()
		local my_num = 3.14
		local t = { 2, 3, 4 }
		assert(not tbl.contains_value(t, my_num))
	end)

	ut:test('table does not contain value: string', function()
		local my_str = 'my_str'
		local t = { a_str = 'hello' }
		assert(not tbl.contains_value(t, my_str))
	end)

	ut:test('table contains value: table', function()
		local my_tbl = {1, 2, 3}
		local t = { a_tbl = {1, 2, 3} }
		assert(not tbl.contains_value(t, my_tbl))
	end)

end)

ut:group('tbl.contains_key(t [table], key [string]) -> [bool]', function()

	ut:test('no args', function()
		local success, err = pcall(function() tbl.contains_key() end)
		assert(not success)
	end)

	ut:test('table contains key: bool', function()
		local t = { [false] = 0, [true] = 1 }
		assert(tbl.contains_key(t, false))
	end)

	ut:test('table contains key: number', function()
		local t = { [404] = 0, [101] = 1 }
		assert(tbl.contains_key(t, 404))
	end)

	ut:test('table contains key: string', function()
		local t = { greeting='hello', farewell='goodbye' }
		assert(tbl.contains_key(t, 'greeting'))
	end)

	ut:test('table contains key: function', function()
		local fn = function(v) return v end
		local t = { [fn] = 1.32 }
		assert(tbl.contains_key(t, fn))
	end)

	ut:test('table contains key: table', function()
		local _t = {1, 2, 3}
		local t = { [_t] = 1.32 }
		assert(tbl.contains_key(t, _t))
	end)

	ut:test('table does not contain key: bool', function()
		local t = { [true] = 1 }
		assert(not tbl.contains_key(t, false))
	end)

	ut:test('table does not contain key: number', function()
		local t = { [404] = 0, [101] = 1 }
		assert(not tbl.contains_key(t, 4))
	end)

	ut:test('table does not contain key: string', function()
		local t = { greeting='hello', farewell='goodbye' }
		assert(not tbl.contains_key(t, 'prelude'))
	end)

	ut:test('table does not contain key: function', function()
		local fn = function(v) return v end
		local t = { [function(v) return v end]=12 }
		assert(not tbl.contains_key(t, fn))
	end)

	ut:test('table does not contain key: table', function()
		local _t1 = {1, 2, 3}
		local _t2 = {1, 2, 3}
		local t = { [_t2] = 1.32 }
		assert(not tbl.contains_key(t, _t1))
	end)

end)

ut:group('tbl.all(t [table], fn [function]) -> [bool]', function()

	ut:test('no args', function()
		local success, err = pcall(function() tbl.all() end)
		assert(not success)
	end)

	ut:test('args[0] must be a table', function()
		local success, err = pcall(function() tbl.all(0, function() return 'hello' end) end)
		assert(not success)
	end)

	ut:test('args[1] missing', function()
		local success, err = pcall(function() tbl.all({1, 2, 3}) end)
		assert(not success)
	end)

	ut:test('args[1] must be a function', function()
		local success, err = pcall(function() tbl.all({1, 2, 3}, 0) end)
		assert(not success)
	end)

	ut:test('table does not match', function()
		local match = tbl.all({1, 2, 3, 5}, function(k, v) return v == 2 end)
		assert(not match)
	end)

	ut:test('table matches', function()
		local match = tbl.all({1, 2, 3, 5}, function(k, v) return k % 1 == 0 end)
		assert(match)
	end)

end)

ut:group('tbl.any(t [table], fn [function]) -> [bool]', function()

	ut:test('no args', function()
		local success, err = pcall(function() tbl.any() end)
		assert(not success)
	end)

	ut:test('args[0] must be a table', function()
		local success, err = pcall(function() tbl.any(0, function() return 'hello' end) end)
		assert(not success)
	end)

	ut:test('args[1] must be a function', function()
		local success, err = pcall(function() tbl.any({1, 2}, 0) end)
		assert(not success)
	end)

	ut:test('table matches', function()
		local match = tbl.any({1, 2, 3, 4}, function(k, v) return k % 2 == 0 end)
		assert(match)
	end)

	ut:test('table does not match', function()
		local match = tbl.any({1, 2, 3, 4}, function(k, v) return k % 5 == 0 end)
		assert(not match)
	end)

end)

ut:group('tbl.reduce(t [table], fn [function], first [any]) -> [any]', function()

	ut:test('sum', function()
		local sum = tbl.reduce({1, 2, 3}, function(acc, v)
			return acc + v
		end, 0)
		assert(sum == 6)
	end)

	ut:test('bool', function()
		local all_even = tbl.reduce({2, 4, 6}, function(acc, v)
			return acc and (v % 2 == 0)
		end, true)
		assert(all_even)
	end)

end)
