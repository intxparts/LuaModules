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
        assert(type(clone) == 'table')
        assert(#clone == 8)
    end)

    test_lab:test('table within table', function()
        local initial_table = { greeting='hello', data={ 1, 2, 3, 5, 7 }}
        local clone = tbl.clone(initial_table)
        assert(type(clone) == 'table')
        assert(tbl.count(clone) == 2)
        assert(type(clone.greeting) == 'string')
        assert(clone.greeting == 'hello')
        assert(type(clone.data) == 'table')
        assert(#clone.data == 5)
    end)
end)

test_lab:group('tbl.equal(t1 [table], t2 [table]) ->', function()
    local vector = require('vector')
    test_lab:test('basic table', function()
        assert(tbl.equal({1, 2, 3}, {1, 2, 3}))
    end)

    test_lab:test('vector table', function()
        assert(tbl.equal(vector.new(0, 0, 1), vector.new(0, 0, 1)))
    end)

    test_lab:test('vector table different', function()
        assert(not tbl.equal(vector.new(1, 0, 1), vector.new(0, 0, 1)))
    end)
end)
