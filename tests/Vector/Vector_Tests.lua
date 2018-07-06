package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local test_lab = require('test_lab')
local vector = require('vector')

test_lab:group('vector.new ->', function()
    test_lab:test('create new vector', function()
        local v1 = vector.new(0, 1, 0)
        assert(v1.x == 0 and v1.y == 1 and v1.z == 0)
    end)

    -- ensure the default vector is the origin (0,0,0)
    test_lab:test('create new vector with no args', function()
        local v1 = vector.new()
        assert(v1.x == 0 and v1.y == 0 and v1.z == 0)
    end)

    -- ensure each new vector is a different instance
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

    test_lab:test('compare two vectors with the same value', function()
        local v1 = vector.new(1, 0, 0)
        local v2 = vector.new(1, 0, 0)
        assert(v1 == v2)
    end)

    test_lab:test('compare two vectors with different values', function()
        local v1 = vector.new(1, 0, 0)
        local v2 = vector.new(0, 0, 1)
        assert(v1 ~= v2)
    end)
end)

test_lab:group('vector.mag ->', function()
    test_lab:test('mag(zero())', function()
        local v1 = vector.new(0, 0, 0)
        assert(vector.mag(v1) == 0)
    end)

    test_lab:test('mag(unit())', function()
        local v1 = vector.new(0, 1, 0)
        assert(vector.mag(v1) == 1)
    end)

    test_lab:test('mag(<3, 4, 5>)', function()
        local v1 = vector.new(3, 4, 5)
        assert(vector.mag(v1) == math.sqrt(50))
    end)
end)

test_lab:group('vector.mag2 ->', function()
    test_lab:test('mag2(zero())', function()
        local v1 = vector.new(0, 0, 0)
        assert(vector.mag2(v1) == 0)
    end)

    test_lab:test('mag2(unit())', function()
        local v1 = vector.new(0, 1, 0)
        assert(vector.mag2(v1) == 1)
    end)

    test_lab:test('mag2(<3, 4, 5>)', function()
        local v1 = vector.new(3, 4, 5)
        assert(vector.mag2(v1) == 50)
    end)
end)