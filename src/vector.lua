local vector = {}
vector.__index = vector

--
-- Instance independent functions
--
local function vector_new(x, y, z)
    local v = { x=x, y=y, z=z }
    setmetatable(v, vector)
    return v
end

local function vector_from_points(p1, p2)
    return vector_new(
        p2.x - p1.x, 
        p2.y - p1.y, 
        p2.z - p1.z
    )
end

local function vector_equal(v1, v2)
    return v1.x == v2.x and v1.y == v2.y and v1.z == v2.z
end

local function vector_mag(v)
    return math.sqrt(vector_mag2(v))
end

local function vector_mag2(v)
    return vector_dot(v, v)
end

local function vector_dot(v1, v2)
    return v1.x*v2.x + v1.y*v2.y + v1.z*v2.z
end

local function vector_cross(v1, v2)
    return vector_new(
        v1.y*v2.z - v1.z*v2.y,
        v1.z*v2.x - v1.x*v2.z, 
        v1.x*v2.y - v1.y*v2.x
    )
end

local function vector_add(v1, v2)
    return vector_new(
        v1.x + v2.x,
        v1.y + v2.y,
        v1.z + v2.z
    )
end

local function vector_sub(v1, v2)
    return vector_new(
        v1.x - v2.x,
        v1.y - v2.y,
        v1.z - v2.z
    )
end

local function vector_mul(k, v)
    return vector_new(
        v.x*k,
        v.y*k,
        v.z*k
    )
end

local function vector_div(v, k)
    assert(k ~= 0)
    return vector_new(
        v.x / k,
        v.y / k,
        v.z / k
    )
end

local function vector_idiv(v, k)
    assert(k ~= 0)
    return vector_new(
        v.x // k,
        v.y // k,
        v.z // k
    )
end

--
-- Metatable overrides
--
vector.__add = vector_add
vector.__sub = vector_sub
vector.__mul = vector_mul
vector.__div = vector_div
vector.__idiv = vector_idiv
vector.__eq = vector_equal

-- 
-- Module exports
--
vector.new = vector_new
vector.dot = vector_dot
vector.cross = vector_cross
vector.mag = vector_mag
vector.mag2 = vector_mag2
vector.from_points = vector_from_points

--
-- Instance dependent functions
--

-- v1 = v1 + v2
function vector:_add(v)
    self.x = self.x + v.x
    self.y = self.y + v.y
    self.z = self.z + v.z
    return self
end

-- v1 = v1 - v2 
function vector:_sub(v)
    self.x = self.x - v.x
    self.y = self.y - v.y
    self.z = self.z - v.z
    return self
end

-- v1 = v1 * k
function vector:_mul(k)
    self.x = self.x * k
    self.y = self.y * k
    self.z = self.z * k
    return self
end

-- v1 = v1 / k
function vector:_div(k)
    self.x = self.x / k
    self.y = self.y / k
    self.z = self.z / k
    return self
end

-- v1 = v1 // k
function vector:_idiv(k)
    self.x = self.x // k
    self.y = self.y // k
    self.z = self.z // k
    return self
end

function vector:mag()
    return vector_mag(self)
end

function vector:dot(v)
    return vector_dot(self, v)
end

function vector:cross(v)
    return vector_cross(self, v)
end

return vector
