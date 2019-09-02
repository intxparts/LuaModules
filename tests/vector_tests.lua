package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local test_lab = require('test_lab')
local vector = require('vector')

test_lab:group('vector.new(x [number], y [number], z [number]) -> [vector]', function()
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

test_lab:group('vector.zero() -> [vector<0,0,0>]', function()
    test_lab:test('= <0, 0, 0>', function()
        local v1 = vector.zero()
        assert(v1.x == 0 and v1.y == 0 and v1.z == 0)
    end)
end)

test_lab:group('vector.from_points(p1 [table], p2 [table]) -> [vector<p2.x - p1.x, p2.y - p1.y, p2.z - p1.z>]', function()
    test_lab:test('create new vector', function()
        local p1 = { x=0, y=1, z=1 }
        local p2 = { x=-1, y=0, z=0 }
        local v1 = vector.from_points(p1, p2)
        assert(v1.x == -1 and v1.y == -1 and v1.z == -1)
    end)
end)

test_lab:group('vector.dot(v1 [table], v2 [table] -> [number<v1.x*v2.x + v1.y*v2.y + v1.z*v2.z>]', function()
    test_lab:test('sum of multiplied components', function()
        local v1 = vector.new(1, -2, 1)
        local v2 = vector.new(0, 3, 4)
        assert(vector.dot(v1, v2) == -2)
    end)
end)

test_lab:group('vector:dot(v [table]) -> [number<self.x*v.x + self.y*v.y + self.z*v.z>]', function()
    test_lab:test('sum of multiplied components', function()
        local v1 = vector.new(1, -2, 1)
        local v2 = vector.new(0, 3, 4)
        assert(v1:dot(v2) == -2)
    end)
end)

test_lab:group('vector.cross(v1 [table], v2 [table]) -> [vector]', function()
    test_lab:test('<1, 0, 0> X <0, 1, 0> = <0, 0, 1>', function()
        local v1 = vector.new(1, 0, 0)
        local v2 = vector.new(0, 1, 0)
        local actual = vector.cross(v1, v2)
        assert(vector.new(0, 0, 1) == actual)
    end)

    test_lab:test('<0, 1, 0> X <1, 0, 0> = <0, 0, -1>', function()
        local v1 = vector.new(0, 1, 0)
        local v2 = vector.new(1, 0, 0)
        local actual = vector.cross(v1, v2)
        assert(vector.new(0, 0, -1) == actual)
    end)

    test_lab:test('<1, 1, 1> X zero() = zero()', function()
        local v1 = vector.new(1, 1, 1)
        local v2 = vector.zero()
        local actual = vector.cross(v1, v2)
        assert(v2 == actual)
    end)

    test_lab:test('parallel vectors crossed = zero()', function()
        local v1 = vector.new(1, 1, 4)
        local v2 = vector.new(2, 2, 8)
        local actual = vector.cross(v1, v2)
        assert(actual == vector.zero())
    end)
end)

test_lab:group('vector:cross(v [table]) -> [vector]', function()
    test_lab:test('<1, 0, 0> X <0, 1, 0> = <0, 0, 1>', function()
        local v1 = vector.new(1, 0, 0)
        local v2 = vector.new(0, 1, 0)
        local actual = v1:cross(v2)
        assert(vector.new(0, 0, 1) == actual)

        -- v:cross is not a self instance modifying function
        assert(v1 ~= actual)
    end)

    test_lab:test('<0, 1, 0> X <1, 0, 0> = <0, 0, -1>', function()
        local v1 = vector.new(0, 1, 0)
        local v2 = vector.new(1, 0, 0)
        local actual = v1:cross(v2)
        assert(vector.new(0, 0, -1) == actual)
    end)

    test_lab:test('<1, 1, 1> X zero() = zero()', function()
        local v1 = vector.new(1, 1, 1)
        local v2 = vector.zero()
        local actual = v1:cross(v2)
        assert(v2 == actual)
    end)

    test_lab:test('parallel vectors crossed = zero()', function()
        local v1 = vector.new(1, 1, 4)
        local v2 = vector.new(2, 2, 8)
        local actual = v1:cross(v2)
        assert(actual == vector.zero())
    end)
end)

test_lab:group('vector.mag(v [table]) -> [number<math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z)>]', function()
    test_lab:test('mag(zero())', function()
        local v1 = vector.zero()
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

test_lab:group('vector.mag2(v [table]) -> [number<v.x*v.x + v.y*v.y + v.z*v.z>]', function()
    test_lab:test('mag2(zero())', function()
        local v1 = vector.zero()
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

test_lab:group('vector.__eq(v1 [table], v2 [table]) -> [boolean]', function()
    test_lab:test('compare same vector', function()
        local v1 = vector.new(1, 0, 0)
        local v2 = v1
        assert(v1 == v2)
        -- remove the vector metatable to compare that the tables are indeed the same instances of vector
        setmetatable(v1, nil)
        setmetatable(v2, nil)
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

test_lab:group('vector.__add(v1 [table], v2 [table]) -> [vector<v1.x + v2.x, v1.y + v2.y, v1.z + v2.z>]', function()
    test_lab:test('same vector', function()
        local v1 = vector.new(1, -1, 1)
        local actual = v1 + v1
        assert(vector.new(2, -2, 2) == actual)
    end)

    test_lab:test('different vectors', function()
        local v1 = vector.new(1, 0, 1)
        local v2 = vector.new(0, 2, -1)
        local actual = v1 + v2
        assert(vector.new(1, 2, 0) == actual)
    end)
end)

test_lab:group('vector.__sub(v1 [table], v2 [table] -> [vector<v1.x - v2.x, v1.y - v2.y, v1.z - v2.z>]', function()
    test_lab:test('same vector', function()
        local v1 = vector.new(1, 0, 1)
        local actual = v1 - v1
        assert(vector.zero() == actual)
    end)

    test_lab:test('different vectors', function()
        local v1 = vector.new(0, 0, 1)
        local v2 = vector.new(0, 1, 0)
        local actual = v1 - v2
        assert(vector.new(0, -1, 1) == actual)
    end)
end)

test_lab:group('vector.__mul(l [number, vector], r [vector, number]) -> [vector]', function()

    test_lab:test('0 * v = zero()', function()
        local v1 = vector.new(1, 1, 1)
        local actual = v1 * 0
        assert(vector.zero() == actual)
    end)

    test_lab:test('1 * v = v', function()
        local v1 = vector.new(1, 2, 1)
        local actual = 1 * v1
        assert(v1 == actual)
        -- remove the vector metatable to compare that the tables are indeed different instances of vector
        setmetatable(v1, nil)
        setmetatable(actual, nil)
        assert(v1 ~= actual)
    end)

    test_lab:test('-1.5 * v', function()
        local v1 = vector.new(1, 0, -1)
        local actual =  -1.5 * v1
        assert(vector.new(-1.5, 0, 1.5) == actual)
    end)

	test_lab:test('v * -1.5', function()
        local v1 = vector.new(1, 0, -1)
        local actual =  v1 * -1.5
        assert(vector.new(-1.5, 0, 1.5) == actual)
    end)
end)

test_lab:group('vector.__div(v [vector], k [non-zero number]) -> [vector]', function()
    test_lab:test('v / 0 = error(divide by zero)', function()
        local v1 = vector.new(1, 0, 0)
        local result, message = pcall(function() local v2 = v1 / 0 end)
        assert(result == false)
        assert(string.find(message, 'error: divide by zero'))
    end)

    test_lab:test('v / 1 = v', function()
        local v1 = vector.new(2, 1, 3)
        local actual = v1 / 1
        assert(v1 == actual)
        -- remove the vector metatable to compare that the tables are indeed different instances of vector
        setmetatable(v1, nil)
        setmetatable(actual, nil)
        assert(v1 ~= actual)
    end)

    test_lab:test('v / 2', function()
        local v1 = vector.new(1, 2, -4)
        local actual = v1 / 2
        assert(vector.new(0.5, 1, -2) == actual)
    end)
end)

test_lab:group('vector.__tostring(v [vector]) -> [string "<v.x, v.y, v.z>"]', function()
    test_lab:test('tostring(zero()) = <0, 0, 0>', function()
        assert(tostring(vector.new(0, 0, 0)) == '<0, 0, 0>')
    end)

    test_lab:test('tostring(<1, 2, -6>) = <1, 2, -6>', function()
        assert(tostring(vector.new(1, 2, -6)) == '<1, 2, -6>')
    end)
end)

--[[
-- vector self instance modification tests 
--]]
test_lab:group('vector:set(x [number], y [number], z [number]) ->', function()
    test_lab:test('change current x,y,z values', function()
        local v1 = vector.new(-1, 2, 0)
        v1:set(0, 1, 0)
        assert(v1.x == 0 and v1.y == 1, v1.z == 0)
    end)
end)

test_lab:group('vector:_add(v [table]) -> [self<self.x + v.x, self.y + v.y, self.z + v.z>]', function()
    test_lab:test('add zero() to current vector', function()
        local v1 = vector.new(1, 2, 4)
        local v2 = vector.zero()
        local actual = v1:_add(v2)
        assert(actual == v1)

        -- remove the vector metatable to compare that the tables are indeed the same instance of vector
        setmetatable(v1, nil)
        setmetatable(actual, nil)
        assert(v1 == actual)
    end)

    test_lab:test('add non-zero vector to current vector', function()
        local v1 = vector.new(1, 2, 4)
        local v2 = vector.new(-1, 1, -5)
        local actual = v1:_add(v2)
        local expected = vector.new(0, 3, -1)
        assert(expected == v1)
        assert(expected == actual)

        -- remove the vector metatable to compare that the tables are indeed the same instance of vector
        setmetatable(v1, nil)
        setmetatable(actual, nil)
        assert(v1 == actual)
    end)
end)

test_lab:group('vector:_sub(v [table]) -> [self<self.x - v.x, self.y - v.y, self.z - v.z>]', function()
    test_lab:test('subtract vector from current vector', function()
        local v1 = vector.new(1, -1, 2)
        local v2 = vector.new(0, 2, 1)
        local actual = v1:_sub(v2)
        local expected = vector.new(1, -3, 1)
        assert(expected == v1)
        assert(expected == actual)

        -- remove the vector metatable to compare that the tables are indeed the same instance of vector
        setmetatable(v1, nil)
        setmetatable(actual, nil)
        assert(v1 == actual)
    end)
end)

test_lab:group('vector:_mul(k [number]) -> [self<v.x*k, v.y*k, v.z*k>]', function()
    test_lab:test('apply a scalar to the current vector', function()
        local v1 = vector.new(1.5, -2, 1)
        local actual = v1:_mul(-2)
        local expected = vector.new(-3, 4, -2)
        assert(expected == v1)
        assert(expected == actual)

        -- remove the vector metatable to compare that the tables are indeed the same instance of vector
        setmetatable(v1, nil)
        setmetatable(actual, nil)
        assert(v1 == actual)
    end)
end)

test_lab:group('vector:_div(k [non-zero number]) -> [self<v.x/k, v.y/k, v.z/k>]', function()
    test_lab:test('divide current vector by a scalar', function()
        local v1 = vector.new(2, -3, 1)
        local actual = v1:_div(2)
        local expected = vector.new(1, -1.5, 0.5)
        assert(expected == v1)
        assert(expected == actual)

        -- remove the vector metatable to compare that the tables are indeed the same instance of vector
        setmetatable(v1, nil)
        setmetatable(actual, nil)
        assert(v1 == actual)
    end)
end)
