package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'
local test_lab = require('test_lab')

test_lab:group('success tests ->', function()
    test_lab:before_each(function() print('>>before each') end)
    test_lab:after(function() print('>>after') end)

    test_lab:test('test 1', function()
        assert(1 == 1)
    end)

    test_lab:test('test 2', function()
        assert(1 ~= 2)
    end)
end)

test_lab:group('failure tests ->', function()
    test_lab:before(function() print('>>before') end)
    test_lab:after_each(function() print('>>after each') end)
    
    test_lab:test('test 3', function()
        assert(1 == 2, 'expected failure') 
    end)

    test_lab:test('test 4', function()
        assert(1 == 3, 'expected failure') 
    end)
end)

