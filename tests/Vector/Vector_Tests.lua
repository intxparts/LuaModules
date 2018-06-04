package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local test_lab = require('test_lab')
local vector = require('vector')

test_lab:group('vector.new ->', function()
    test_lab:test('create new vector', function()
        local v1 = vector.new(0, 1, 0)
        assert(v1.x == 0 and v1.y == 1 and v1.z == 0)
    end)

    test_lab:test('create multiple vectors', function()
        local v1 = vector.new(0, 1, 0)
        local v2 = vector.new(0, 0, 1)
        assert(v1.x == 0 and v1.y == 1 and v1.z == 0)
        assert(v2.x == 0 and v2.y == 0 and v2.z == 1)        
    end)
end)

test_lab:group('vector.from_points ->', function()
    test_lab:test('create new vector', function()
        local p1 = { x=0, y=1, z=1 }
        local p2 = { x=-1, y=0, z=0 }
        local v1 = vector.from_points(p1, p2)
        assert(v1.x == -1 and v1.y == -1 and v1.z == -1)
    end)
end)

test_lab:group('vector.equal ->', function()
    test_lab:test('compare same vector', function()
        local v1 = vector.new(1, 0, 0)
        local v2 = v1
        assert(v1 == v2)
    end)

    test_lab:test('compare vector with the same value', function()
        local v1 = vector.new(1, 0, 0)
        local v2 = vector.new(1, 0, 0)
        assert(v1 == v2)
    end)

    test_lab:test('compare vector with different values', function()
        local v1 = vector.new(1, 0, 0)
        local v2 = vector.new(0, 0, 1)
        assert(v1 ~= v2)
    end)
end)