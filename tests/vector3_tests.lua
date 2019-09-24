package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local test_lab = require('test_lab')
local vector3 = require('vector3')

test_lab:group('vector3.new(x [number], y [number], z [number]) -> [vector3]', function()
    test_lab:test('create new vector3', function()
        local v1 = vector3.new(0, 1, 0)
        assert(v1[1] == 0 and v1[2] == 1 and v1[3] == 0)
    end)

    -- ensure the default vector3 is the origin (0,0,0)
    test_lab:test('create new vector3 with no args', function()
        local v1 = vector3.new()

        assert(v1[1] == 0 and v1[2] == 0 and v1[3] == 0)
    end)

    -- ensure each new vector3 is a different instance
    test_lab:test('create multiple vector3s', function()
        local v1 = vector3.new(0, 1, 0)
        local v2 = vector3.new(0, 0, 1)
        assert(v1[1] == 0 and v1[2] == 1 and v1[3] == 0)
        assert(v2[1] == 0 and v2[2] == 0 and v2[3] == 1)
    end)
end)

test_lab:group('vector3.zero() -> [vector3<0,0,0>]', function()
    test_lab:test('== <0, 0, 0>', function()
        local v1 = vector3.zero()
        assert(v1[1] == 0 and v1[2] == 0 and v1[3] == 0)
    end)
end)

test_lab:group('vector3.from_points(p1 [table], p2 [table]) -> [vector3<p2[1] - p1[1], p2[2] - p1[2], p2[3] - p1[3]>]', function()
    test_lab:test('create new vector3', function()
        local p1 = { 0, 1, 1 }
        local p2 = { 1, 0, 0 }
        local v1 = vector3.from_points(p1, p2)
        assert(v1[1] == 1 and v1[2] == -1 and v1[3] == -1)
    end)
end)

test_lab:group('vector3.dot(v1 [table], v2 [table] -> [number<v1[1]*v2[1] + v1[2]*v2[2] + v1[3]*v2[3]>]', function()
    test_lab:test('sum of multiplied components', function()
        local v1 = vector3.new(1, -2, 1)
        local v2 = vector3.new(0, 3, 4)
        assert(vector3.dot(v1, v2) == -2)
    end)
end)

test_lab:group('vector3:dot(v [table]) -> [number<self[1]*v[1] + self[2]*v[2] + self[3]*v[3]>]', function()
    test_lab:test('sum of multiplied components', function()
        local v1 = vector3.new(1, -2, 1)
        local v2 = vector3.new(0, 3, 4)
        assert(v1:dot(v2) == -2)
    end)
end)

test_lab:group('vector3.cross(v1 [table], v2 [table]) -> [vector3]', function()
    test_lab:test('<1, 0, 0> X <0, 1, 0> = <0, 0, 1>', function()
        local v1 = vector3.new(1, 0, 0)
        local v2 = vector3.new(0, 1, 0)
        local actual = vector3.cross(v1, v2)
        assert(vector3.new(0, 0, 1) == actual)
    end)

    test_lab:test('<0, 1, 0> X <1, 0, 0> = <0, 0, -1>', function()
        local v1 = vector3.new(0, 1, 0)
        local v2 = vector3.new(1, 0, 0)
        local actual = vector3.cross(v1, v2)
        assert(vector3.new(0, 0, -1) == actual)
    end)

    test_lab:test('<1, 1, 1> X zero() = zero()', function()
        local v1 = vector3.new(1, 1, 1)
        local v2 = vector3.zero()
        local actual = vector3.cross(v1, v2)
        assert(v2 == actual)
    end)

    test_lab:test('parallel vector3s crossed = zero()', function()
        local v1 = vector3.new(1, 1, 4)
        local v2 = vector3.new(2, 2, 8)
        local actual = vector3.cross(v1, v2)
        assert(actual == vector3.zero())
    end)
end)

test_lab:group('vector3:cross(v [table]) -> [vector3]', function()
    test_lab:test('<1, 0, 0> X <0, 1, 0> = <0, 0, 1>', function()
        local v1 = vector3.new(1, 0, 0)
        local v2 = vector3.new(0, 1, 0)
        local actual = v1:cross(v2)
        assert(vector3.new(0, 0, 1) == actual)

        -- v:cross is not a self instance modifying function
        assert(v1 ~= actual)
    end)

    test_lab:test('<0, 1, 0> X <1, 0, 0> = <0, 0, -1>', function()
        local v1 = vector3.new(0, 1, 0)
        local v2 = vector3.new(1, 0, 0)
        local actual = v1:cross(v2)
        assert(vector3.new(0, 0, -1) == actual)
    end)

    test_lab:test('<1, 1, 1> X zero() = zero()', function()
        local v1 = vector3.new(1, 1, 1)
        local v2 = vector3.zero()
        local actual = v1:cross(v2)
        assert(v2 == actual)
    end)

    test_lab:test('parallel vector3s crossed = zero()', function()
        local v1 = vector3.new(1, 1, 4)
        local v2 = vector3.new(2, 2, 8)
        local actual = v1:cross(v2)
        assert(actual == vector3.zero())
    end)
end)

test_lab:group('vector3.mag(v [table]) -> [number<math.sqrt(v[1]*v[1] + v[2]*v[2] + v[3]*v[3])>]', function()
    test_lab:test('mag(zero())', function()
        local v1 = vector3.zero()
        assert(vector3.mag(v1) == 0)
    end)

    test_lab:test('mag(unit())', function()
        local v1 = vector3.new(0, 1, 0)
        assert(vector3.mag(v1) == 1)
    end)

    test_lab:test('mag(<3, 4, 5>)', function()
        local v1 = vector3.new(3, 4, 5)
        assert(vector3.mag(v1) == math.sqrt(50))
    end)
end)

test_lab:group('vector3.mag2(v [table]) -> [number<v[1]*v[1] + v[2]*v[2] + v[3]*v[3]>]', function()
    test_lab:test('mag2(zero())', function()
        local v1 = vector3.zero()
        assert(vector3.mag2(v1) == 0)
    end)

    test_lab:test('mag2(unit())', function()
        local v1 = vector3.new(0, 1, 0)
        assert(vector3.mag2(v1) == 1)
    end)

    test_lab:test('mag2(<3, 4, 5>)', function()
        local v1 = vector3.new(3, 4, 5)
        assert(vector3.mag2(v1) == 50)
    end)
end)

test_lab:group('vector3.__eq(v1 [table], v2 [table]) -> [boolean]', function()
    test_lab:test('compare same vector3', function()
        local v1 = vector3.new(1, 0, 0)
        local v2 = v1
        assert(v1 == v2)
        -- remove the vector3 metatable to compare that the tables are indeed the same instances of vector3
        setmetatable(v1, nil)
        setmetatable(v2, nil)
        assert(v1 == v2)
    end)

    test_lab:test('compare two vector3s with the same value', function()
        local v1 = vector3.new(1, 0, 0)
        local v2 = vector3.new(1, 0, 0)
        assert(v1 == v2)
    end)

    test_lab:test('compare two vector3s with different values', function()
        local v1 = vector3.new(1, 0, 0)
        local v2 = vector3.new(0, 0, 1)
        assert(v1 ~= v2)
    end)
end)

test_lab:group('vector3.__add(v1 [table], v2 [table]) -> [vector3<v1[1] + v2[1], v1[2] + v2[2], v1[3] + v2[3]>]', function()
    test_lab:test('same vector3', function()
        local v1 = vector3.new(1, -1, 1)
        local actual = v1 + v1
        assert(vector3.new(2, -2, 2) == actual)
    end)

    test_lab:test('different vector3s', function()
        local v1 = vector3.new(1, 0, 1)
        local v2 = vector3.new(0, 2, -1)
        local actual = v1 + v2
        assert(vector3.new(1, 2, 0) == actual)
    end)
end)

test_lab:group('vector3.__sub(v1 [table], v2 [table] -> [vector3<v1[1] - v2[1], v1[2] - v2[2], v1[3] - v2[3]>]', function()
    test_lab:test('same vector3', function()
        local v1 = vector3.new(1, 0, 1)
        local actual = v1 - v1
        assert(vector3.zero() == actual)
    end)

    test_lab:test('different vector3s', function()
        local v1 = vector3.new(0, 0, 1)
        local v2 = vector3.new(0, 1, 0)
        local actual = v1 - v2
        assert(vector3.new(0, -1, 1) == actual)
    end)
end)

test_lab:group('vector3.__mul(l [number, vector3], r [vector3, number]) -> [vector3]', function()

    test_lab:test('0 * v = zero()', function()
        local v1 = vector3.new(1, 1, 1)
        local actual = v1 * 0
        assert(vector3.zero() == actual)
    end)

    test_lab:test('1 * v = v', function()
        local v1 = vector3.new(1, 2, 1)
        local actual = 1 * v1
        assert(v1 == actual)
        -- remove the vector3 metatable to compare that the tables are indeed different instances of vector3
        setmetatable(v1, nil)
        setmetatable(actual, nil)
        assert(v1 ~= actual)
    end)

    test_lab:test('-1.5 * v', function()
        local v1 = vector3.new(1, 0, -1)
        local actual =  -1.5 * v1
        assert(vector3.new(-1.5, 0, 1.5) == actual)
    end)

	test_lab:test('v * -1.5', function()
        local v1 = vector3.new(1, 0, -1)
        local actual =  v1 * -1.5
        assert(vector3.new(-1.5, 0, 1.5) == actual)
    end)
end)

--[[
test_lab:group('vector3.__div(v [vector3], k [non-zero number]) -> [vector3]', function()
    test_lab:test('v / 0 = error(divide by zero)', function()
        local v1 = vector3.new(1, 0, 0)
        local result, message = pcall(function() local v2 = v1 / 0 end)
        assert(result == false)
        assert(string.find(message, 'error: divide by zero'))
    end)

    test_lab:test('v / 1 = v', function()
        local v1 = vector3.new(2, 1, 3)
        local actual = v1 / 1
        assert(v1 == actual)
        -- remove the vector3 metatable to compare that the tables are indeed different instances of vector3
        setmetatable(v1, nil)
        setmetatable(actual, nil)
        assert(v1 ~= actual)
    end)

    test_lab:test('v / 2', function()
        local v1 = vector3.new(1, 2, -4)
        local actual = v1 / 2
        assert(vector3.new(0.5, 1, -2) == actual)
    end)
end)
--]]

test_lab:group('vector3.__tostring(v [vector3]) -> [string "<v[1], v[2], v[3]>"]', function()
    test_lab:test('tostring(zero()) = <0, 0, 0>', function()
        assert(tostring(vector3.new(0, 0, 0)) == '<0, 0, 0>')
    end)

    test_lab:test('tostring(<1, 2, -6>) = <1, 2, -6>', function()
        assert(tostring(vector3.new(1, 2, -6)) == '<1, 2, -6>')
    end)
end)

--[[
-- vector3 self instance modification tests 
--]]
test_lab:group('vector3:set(x [number], y [number], z [number]) ->', function()
    test_lab:test('change current x,y,z values', function()
        local v1 = vector3.new(-1, 2, 0)
        v1:set(0, 1, 0)
        assert(v1[1] == 0 and v1[2] == 1, v1[3] == 0)
    end)
end)

test_lab:group('vector3:_add(v [table]) -> [self<self[1] + v[1], self[2] + v[2], self[3] + v[3]>]', function()
    test_lab:test('add zero() to current vector3', function()
        local v1 = vector3.new(1, 2, 4)
        local v2 = vector3.zero()
        local actual = v1:_add(v2)
        assert(actual == v1)

        -- remove the vector3 metatable to compare that the tables are indeed the same instance of vector3
        setmetatable(v1, nil)
        setmetatable(actual, nil)
        assert(v1 == actual)
    end)

    test_lab:test('add non-zero vector3 to current vector3', function()
        local v1 = vector3.new(1, 2, 4)
        local v2 = vector3.new(-1, 1, -5)
        local actual = v1:_add(v2)
        local expected = vector3.new(0, 3, -1)
        assert(expected == v1)
        assert(expected == actual)

        -- remove the vector3 metatable to compare that the tables are indeed the same instance of vector3
        setmetatable(v1, nil)
        setmetatable(actual, nil)
        assert(v1 == actual)
    end)
end)

test_lab:group('vector3:_sub(v [table]) -> [self<self[1] - v[1], self[2] - v[2], self[3] - v[3]>]', function()
    test_lab:test('subtract vector3 from current vector3', function()
        local v1 = vector3.new(1, -1, 2)
        local v2 = vector3.new(0, 2, 1)
        local actual = v1:_sub(v2)
        local expected = vector3.new(1, -3, 1)
        assert(expected == v1)
        assert(expected == actual)

        -- remove the vector3 metatable to compare that the tables are indeed the same instance of vector3
        setmetatable(v1, nil)
        setmetatable(actual, nil)
        assert(v1 == actual)
    end)
end)

test_lab:group('vector3:_scale(k [number]) -> [self<v[1]*k, v[2]*k, v[3]*k>]', function()
    test_lab:test('apply a scalar to the current vector3', function()
        local v1 = vector3.new(1.5, -2, 1)
        local actual = v1:_scale(-2)
        local expected = vector3.new(-3, 4, -2)
        assert(expected == v1)
        assert(expected == actual)

        -- remove the vector3 metatable to compare that the tables are indeed the same instance of vector3
        setmetatable(v1, nil)
        setmetatable(actual, nil)
        assert(v1 == actual)
    end)
end)

--[[
test_lab:group('vector3:div(k [non-zero number]) -> [self<v[1]/k, v[2]/k, v[3]/k>]', function()
    test_lab:test('divide current vector3 by a scalar', function()
        local v1 = vector3.new(2, -3, 1)
        local actual = v1:div(2)
        local expected = vector3.new(1, -1.5, 0.5)
        assert(expected == v1)
        assert(expected == actual)

        -- remove the vector3 metatable to compare that the tables are indeed the same instance of vector3
        setmetatable(v1, nil)
        setmetatable(actual, nil)
        assert(v1 == actual)
    end)
end)
--]]
