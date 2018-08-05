package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local test_lab = require('test_lab')
local fnl = require('fnl')

test_lab:group('fnl.clone ->', function()

    test_lab:test('basic table', function()
        local initial_table = { 1, 2, 3, 4, 5, 6, 7, 8 }
        local clone = fnl.clone(initial_table)
        assert(type(clone) == 'table')
        assert(#clone == 8)
    end)

    test_lab:test('table within table', function()
        local initial_table = { greeting='hello', data={ 1, 2, 3, 5, 7 }}
        local clone = fnl.clone(initial_table)
        assert(type(clone) == 'table')
        assert(fnl.count(clone) == 2)
        assert(type(clone.greeting) == 'string')
        assert(clone.greeting == 'hello')
        assert(type(clone.data) == 'table')
        assert(#clone.data == 5)
    end)
end)


