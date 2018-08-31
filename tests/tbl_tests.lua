package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local test_lab = require('test_lab')
local tbl = require('tbl')

test_lab:group('tbl.count(t [table], fn [function]) ->', function()
    test_lab:test('empty table', function()
        assert(0 == tbl.count({}))
    end)

    test_lab:test('array table', function()
        assert(3 == tbl.count({ 1, 2, 3 }))
    end)

    test_lab:test('dictionary table', function()
        assert(2 == tbl.count({greeting='hello', farewell='goodbye'}))
    end)

    test_lab:test('holey table', function()
        assert(5 == tbl.count({ [1]=2, [2]=3, [3]=5, [5]=7, [7]=11 }))
    end)

    test_lab:test('empty table, where idx is odd', function()
        assert(0 == tbl.count({}, function(k, v) return k % 2 ~= 0 end))
    end)

    test_lab:test('array table, where value is even', function()
        assert(1 == tbl.count({ 1, 2, 3 }, function(k, v) return v % 2 == 0 end))
    end)

    test_lab:test("dictionary table, where value contains 'o'", function()
        assert(2 == tbl.count({greeting='hello', farewell='goodbye'}, function(k, v) return string.find(v, 'o') ~= nil end))
    end)

    test_lab:test('holey table, where idx is odd', function()
        assert(4 == tbl.count({ [1]=2, [2]=3, [3]=5, [5]=7, [7]=11 }, function(k, v) return k % 2 ~= 0 end))
    end)
end)

test_lab:group('tbl.apply(t [table], fn [function]) ->', function()
    test_lab:test('empty table', function()
        local actual = tbl.apply({}, function(k, v) return v end)

    end)
end)

test_lab:group('tbl.clone(t [table]) ->', function()

    test_lab:test('basic table', function()
        local initial_table = { 1, 2, 3, 4, 5, 6, 7, 8 }
        local clone = tbl.clone(initial_table)
        assert(initial_table ~= clone)
        assert(tbl.deep_equal(initial_table, clone))
    end)

    test_lab:test('table within table', function()
        local initial_table = { greeting='hello', data={ 1, 2, 3, 5, 7 }}
        local clone = tbl.clone(initial_table)
        assert(initial_table ~= clone)
        assert(tbl.deep_equal(initial_table, clone))
    end)
end)

test_lab:group('tbl.deep_equal(t1 [table], t2 [table]) ->', function()
    local vector = require('vector')
    test_lab:test('empty table', function()
        assert(tbl.deep_equal({}, {}))
    end)

    test_lab:test('basic table', function()
        assert(tbl.deep_equal({1, 2, 3}, {1, 2, 3}))
    end)

    test_lab:test('vector table', function()
        assert(tbl.deep_equal(vector.new(0, 0, 1), vector.new(0, 0, 1)))
    end)

    test_lab:test('different vector tables - not equal', function()
        assert(not tbl.deep_equal(vector.new(1, 0, 1), vector.new(0, 0, 1)))
    end)

    test_lab:test('table with different number of key-value pairs - not equal', function()
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

    test_lab:test('table with subtables - equal', function()
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

    test_lab:test('table with subtables -> number within subtable - not equal', function()
        assert(not tbl.deep_equal({{1, 2}}, {{1, 3}}))
    end)

    test_lab:test('table with subtables -> string within subtable - not equal', function()
        assert(not tbl.deep_equal({{1, greeting='hello'}}, {{1, greeting='HELLO'}}))
    end)

    test_lab:test('table with subtables -> bool within subtable - not equal', function()
        assert(not tbl.deep_equal({{1, bool=true}}, {{1, bool=false}}))
    end)
end)

test_lab:group('table wrapped ->', function()
    test_lab:test('t1:deep_equal(t2)', function()
        local t1 = tbl.wrap({1, 2, 3})
        local t2 = tbl.wrap({1, 2, 3})
        assert(t1:deep_equal(t2))
    end)

    test_lab:test('t1:clone()', function()
        local t1 = tbl.wrap({1, 2, 3})
        local t2 = t1:clone()
        assert(t1:deep_equal(t2))
    end)
end)