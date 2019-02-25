package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local test_lab = require('test_lab')
local rect = require('rect')

test_lab:group('rect.new ->', function()

    test_lab:test('rect origin is top-left', function()
        local box = rect.new(0, 0, 10, 20)
        assert(box.x == 0)
        assert(box.y == 0)
        assert(box.right == 10)
        assert(box.left == 0)
        assert(box.top == 0)
        assert(box.bottom == 20)
    end)

    test_lab:test('negative width not permitted', function()
        local result, message = pcall(function() local r = rect.new(0, 0, -10, 20) end)
        assert(result == false)
    end)

    test_lab:test('negative height not permitted', function()
        local result, message = pcall(function() local r = rect.new(0, 0, 10, -20) end)
        assert(result == false)
    end)

end)

