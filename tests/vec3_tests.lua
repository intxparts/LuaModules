package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local test_lab = require('test_lab')
local vec3 = require('vec3')

test_lab:group('vec3.new(x [number], y [number], z [number]) -> [vec3]', function()
    test_lab:test('vec3.new(0,1,0) creates a vec3 at (0,1,0)', function()
        local v1 = vec3.new(0, 1, 0)
        assert(v1.x == 0 and v1.y == 1 and v1.z == 0)
    end)

    test_lab:test('vec3.new() creates a vec3 at the origin (0,0,0)', function()
        local v1 = vec3.new()
        assert(v1.x == 0 and v1.y == 0 and v1.z == 0)
    end)

    test_lab:test('each call to vec3.new() creates a new instance', function()
        local v1 = vec3.new(0, 1, 0)
        local v2 = vec3.new(0, 1, 0)
		assert(v1 ~= v2)
        assert(v1.x == 0 and v1.y == 1 and v1.z == 0)
        assert(v2.x == 0 and v2.y == 1 and v2.z == 0)
    end)
end)

test_lab:group('vec3.zero() -> [vec3]', function()
    test_lab:test('vec3.zero() == <0, 0, 0>', function()
        local v1 = vec3.zero()
        assert(v1.x == 0 and v1.y == 0 and v1.z == 0)
    end)
end)

test_lab:group('vec3.from_points(p1 [table], p2 [table]) -> [vec3]', function()
    test_lab:test('create new vec3', function()
        local p1 = { x=0, y=1, z=1 }
        local p2 = { x=1, y=0, z=0 }
        local v1 = vec3.from_points(p1, p2)
        assert(v1.x == 1 and v1.y == -1 and v1.z == -1)
    end)
end)

test_lab:group('vec3.dot(v1 [table], v2 [table] -> [number]', function()
    test_lab:test('vec3.dot(<1,-2,1>, <0,3,4>) == -2', function()
        local v1 = vec3.new(1, -2, 1)
        local v2 = vec3.new(0, 3, 4)
        assert(vec3.dot(v1, v2) == -2)
    end)

	test_lab:test('v1:dot(v2)', function()
		local v1 = vec3.new(1,2,3)
		local v2 = vec3.new(1,1,0)
		assert(v1:dot(v2) == 3)
	end)
end)

test_lab:group('vec3.cross(v1 [table], v2 [table]) -> [vec3]', function()
    test_lab:test('<1, 0, 0> X <0, 1, 0> = <0, 0, 1>', function()
        local v1 = vec3.new(1, 0, 0)
        local v2 = vec3.new(0, 1, 0)
        local actual = vec3.cross(v1, v2)
        assert(vec3.new(0, 0, 1):equals(actual))
    end)

    test_lab:test('<0, 1, 0> X <1, 0, 0> = <0, 0, -1>', function()
        local v1 = vec3.new(0, 1, 0)
        local v2 = vec3.new(1, 0, 0)
        local actual = vec3.cross(v1, v2)
        assert(vec3.new(0, 0, -1):equals(actual))
    end)

    test_lab:test('<1, 1, 1> X zero() = zero()', function()
        local v1 = vec3.new(1, 1, 1)
        local v2 = vec3.zero()
        local actual = vec3.cross(v1, v2)
        assert(v2:equals(actual))
    end)

    test_lab:test('parallel vec3 crossed = zero()', function()
        local v1 = vec3.new(1, 1, 4)
        local v2 = vec3.new(2, 2, 8)
        local actual = vec3.cross(v1, v2)
        assert(actual:equals(vec3.zero()))
    end)
end)

test_lab:group('vec3:cross(v [table]) -> [vec3]', function()
    test_lab:test('<1, 0, 0> X <0, 1, 0> = <0, 0, 1>', function()
        local v1 = vec3.new(1, 0, 0)
        local v2 = vec3.new(0, 1, 0)
        local actual = v1:cross(v2)
        assert(vec3.new(0, 0, 1):equals(actual))
    end)

    test_lab:test('<0, 1, 0> X <1, 0, 0> = <0, 0, -1>', function()
        local v1 = vec3.new(0, 1, 0)
        local v2 = vec3.new(1, 0, 0)
        local actual = v1:cross(v2)
        assert(vec3.new(0, 0, -1):equals(actual))
    end)

    test_lab:test('<1, 1, 1> X zero() = zero()', function()
        local v1 = vec3.new(1, 1, 1)
        local v2 = vec3.zero()
        local actual = v1:cross(v2)
        assert(v2:equals(actual))
    end)

    test_lab:test('parallel vec3 crossed = zero()', function()
        local v1 = vec3.new(1, 1, 4)
        local v2 = vec3.new(2, 2, 8)
        local actual = v1:cross(v2)
        assert(actual:equals(vec3.zero()))
    end)
end)

test_lab:group('vec3.mag(v [table]) -> [number]', function()
    test_lab:test('mag(zero())', function()
        local v1 = vec3.zero()
        assert(vec3.mag(v1) == 0)
    end)

    test_lab:test('mag(unit())', function()
        local v1 = vec3.new(0, 1, 0)
        assert(vec3.mag(v1) == 1)
    end)

    test_lab:test('mag(3, 4, 5)', function()
        local v1 = vec3.new(3, 4, 5)
        assert(vec3.mag(v1) == math.sqrt(50))
    end)
end)

test_lab:group('vec3.mag2(v [table]) -> [number]', function()
    test_lab:test('mag2(zero())', function()
        local v1 = vec3.zero()
        assert(vec3.mag2(v1) == 0)
    end)

    test_lab:test('mag2(unit())', function()
        local v1 = vec3.new(0, 1, 0)
        assert(vec3.mag2(v1) == 1)
    end)

    test_lab:test('mag2(3, 4, 5)', function()
        local v1 = vec3.new(3, 4, 5)
        assert(vec3.mag2(v1) == 50)
    end)
end)

test_lab:group('vec3.equals(v1 [table], v2 [table]) -> [boolean]', function()
    test_lab:test('compare same vec3', function()
        local v1 = vec3.new(1, 0, 0)
        local v2 = v1
        assert(vec3.equals(v1, v2) and v1 == v2)
    end)

    test_lab:test('compare two vec3 with the same value', function()
        local v1 = vec3.new(1, 0, 0)
        local v2 = vec3.new(1, 0, 0)
        assert(vec3.equals(v1, v2))
    end)

    test_lab:test('compare two vec3 with different values', function()
        local v1 = vec3.new(1, 0, 0)
        local v2 = vec3.new(0, 0, 1)
        assert(not vec3.equals(v1, v2))
    end)
end)

test_lab:group('vec3.add(v1 [table], v2 [table]) -> [vec3]', function()
    test_lab:test('vec3.add(v1, v2)', function()
        local v1 = vec3.new(1, -1, 1)
		local v2 = vec3.new(0, 1, 0)
        local actual = vec3.add(v1, v2)
        assert(vec3.new(1, 0, 1):equals(actual))
    end)

    test_lab:test('v1:add(v2)', function()
        local v1 = vec3.new(1, 0, 1)
        local v2 = vec3.new(0, 2, -1)
        local actual = v1:add(v2)
        assert(vec3.new(1, 2, 0):equals(actual))
    end)
end)

test_lab:group('vec3.sub(v1 [table], v2 [table] -> [vec3]', function()
    test_lab:test('vec3.sub(v1, v2)', function()
        local v1 = vec3.new(1, 0, 1)
        local actual = vec3.sub(v1, v1)
        assert(vec3.zero():equals(actual))
    end)

    test_lab:test('v1:sub(v2)', function()
        local v1 = vec3.new(0, 0, 1)
        local v2 = vec3.new(0, 1, 0)
        local actual = v1:sub(v2)
        assert(vec3.new(0, -1, 1):equals(actual))
    end)
end)

test_lab:group('vec3.tostring(v [vec3]) -> [string]', function()
    test_lab:test('vec3.tostring(zero()) = <0, 0, 0>', function()
        assert(vec3.tostring(vec3.new(0, 0, 0)) == '<0, 0, 0>')
    end)

    test_lab:test('vec3.new(1, 2, -6):tostring() = <1, 2, -6>', function()
        assert(vec3.new(1, 2, -6):tostring() == '<1, 2, -6>')
    end)
end)

test_lab:group('vec3:set(x [number], y [number], z [number]) ->', function()
    test_lab:test('change current x,y,z values', function()
        local v1 = vec3.new(-1, 2, 0)
        v1:set(0, 1, 0)
        assert(v1.x == 0 and v1.y == 1, v1.z == 0)
    end)
end)

test_lab:group('vec3:_add(v [table]) ->', function()
    test_lab:test('add zero() to current vec3', function()
        local v1 = vec3.new(1, 2, 4)
        local v2 = vec3.zero()
        local actual = v1:_add(v2)
		assert(actual == v1) -- same table
        assert(v1.x == 1 and v1.y == 2 and v1.z == 4)
    end)

    test_lab:test('add non-zero vec3 to current vec3', function()
        local v1 = vec3.new(1, 2, 4)
        local v2 = vec3.new(-1, 1, -5)
        local actual = v1:_add(v2)
		assert(actual == v1) -- same table
		assert(v1.x == 0 and v1.y == 3 and v1.z == -1)
    end)
end)

test_lab:group('vec3:_sub(v [table]) -> [self<self.x - v.x, self.y - v.y, self.z - v.z>]', function()
    test_lab:test('subtract vec3 from current vec3', function()
        local v1 = vec3.new(1, -1, 2)
        local v2 = vec3.new(0, 2, 1)
        local actual = v1:_sub(v2)
		assert(actual == v1) -- same table
		assert(v1.x == 1 and v1.y == -3 and v1.z == 1)
    end)
end)

test_lab:group('vec3:_scale(k [number]) -> [self<v.x*k, v.y*k, v.z*k>]', function()
    test_lab:test('apply a scalar to the current vec3', function()
        local v1 = vec3.new(1.5, -2, 1)
        local actual = v1:_scale(-2)
		assert(actual == v1)
		assert(v1.x == -3 and v1.y == 4 and v1.z == -2)
    end)
end)
