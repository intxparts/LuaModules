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

test_lab:group('rect:copy ->', function()
    test_lab:test('same data, different object', function()
        local box1 = rect.new(0, 0, 10, 20)
        local box2 = box1:copy()
        assert(box1.x == box2.x and box1.y == box2.y)
        assert(box1.w == box2.w and box2.h == box2.h)
        assert(box1.left == box2.left and box1.right == box2.right)
        assert(box1.top == box2.top and box1.bottom == box2.bottom)
        assert(box1 ~= box2)
        assert(getmetatable(box1) == getmetatable(box2))
    end)
end)

test_lab:group('rect:contains_point ->', function()
    local box1 = rect.new(0, 0, 10, 10)

    test_lab:test('boundary point - corner', function()
        assert(box1:contains_point(0, 0))
    end)

    test_lab:test('boundary point - edge', function()
        assert(box1:contains_point(2, 10))
    end)

    test_lab:test('external point', function()
        assert(not box1:contains_point(11, 10))
    end)

    test_lab:test('internal point', function()
        assert(box1:contains_point(5, 5))
    end)

end)

test_lab:group('rect:strictly_contains_point ->', function()
    local box1 = rect.new(0, 0, 10, 10)

    test_lab:test('boundary point - corner', function()
        assert(not box1:strictly_contains_point(0, 0))
    end)

    test_lab:test('boundary point - edge', function()
        assert(not box1:strictly_contains_point(2, 10))
    end)

    test_lab:test('external point', function()
        assert(not box1:strictly_contains_point(11, 10))
    end)

    test_lab:test('internal point', function()
        assert(box1:strictly_contains_point(5, 5))
    end)

end)

test_lab:group('rect:has_y_collision ->', function()

    local box1 = rect.new(0, 0, 10, 10)
    test_lab:test('boundary line collision - top', function()
        assert(box1:has_y_collision(rect.new(2, -5, 5, 5)))
    end)

    test_lab:test('boundary line collision - bottom', function()
        assert(box1:has_y_collision(rect.new(0, 10, 5, 5)))
    end)

    test_lab:test('rect.top between other_rect y bounds', function()
        assert(box1:has_y_collision(rect.new(0, -5, 10, 10)))
    end)

    test_lab:test('rect.bottom between other_rect y bounds', function()
        assert(box1:has_y_collision(rect.new(0, 5, 10, 10)))
    end)

    test_lab:test('rect completely contained in other_rect y bounds', function()
        assert(box1:has_y_collision(rect.new(-1, -1, 20, 20)))
    end)

    test_lab:test('other_rect completely contained in y bounds', function()
        assert(box1:has_y_collision(rect.new(11, 1, 3, 3)))
    end)

    test_lab:test('other_rect outside y bounds', function()
        assert(not box1:has_y_collision(rect.new(11, 11, 10, 10)))
    end)
end)

test_lab:group('rect:has_x_collision ->', function()
    local box1 = rect.new(0, 0, 10, 10)
    test_lab:test('boundary line collision - left', function()
        assert(box1:has_x_collision(rect.new(-10, 2, 10, 5)))
    end)

    test_lab:test('boundary line collision - right', function()
        assert(box1:has_x_collision(rect.new(10, 2, 5, 5)))
    end)

    test_lab:test('rect.left between other_rect x bounds', function()
        assert(box1:has_x_collision(rect.new(-5, 2, 10, 10)))
    end)

    test_lab:test('rect.right between other_rect x bounds', function()
        assert(box1:has_x_collision(rect.new(5, 2, 10, 10)))
    end)

    test_lab:test('rect compeletely contained in other_rect x bounds', function()
        assert(box1:has_x_collision(rect.new(-1, -1, 20, 20)))
    end)

    test_lab:test('other_rect completely contained in x bounds', function()
        assert(box1:has_x_collision(rect.new(1, 11, 3, 3)))
    end)

    test_lab:test('other_rect outside x bounds', function()
        assert(not box1:has_x_collision(rect.new(11, 11, 10, 10)))
    end)
end)


