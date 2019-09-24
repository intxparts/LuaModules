local vector3 = {}
vector3.__index = vector3

--
-- Instance independent functions
--
local function vector3_new(x, y, z)
    local v = { [1]=x or 0, [2]=y or 0, [3]=z or 0}
    setmetatable(v, vector3)
    return v
end

local function vector3_zero()
    return vector3_new(0, 0, 0)
end

local function vector3_from_points(p1, p2)
    return vector3_new(
        p2[1] - p1[1],
        p2[2] - p1[2],
        p2[3] - p1[3]
    )
end

local function vector3_dot(v1, v2)
    return v1[1]*v2[1] + v1[2]*v2[2] + v1[3]*v2[3]
end

local function vector3_mag2(v)
    return vector3_dot(v, v)
end

local function vector3_mag(v)
    return math.sqrt(vector3_mag2(v))
end

local function vector3_cross(v1, v2)
    return vector3_new(
        v1[2]*v2[3] - v1[3]*v2[2],
        v1[3]*v2[1] - v1[1]*v2[3],
        v1[1]*v2[2] - v1[2]*v2[1]
    )
end

local function vector3_add(v1, v2)
    return vector3_new(
        v1[1] + v2[1],
        v1[2] + v2[2],
        v1[3] + v2[3]
    )
end

local function vector3_sub(v1, v2)
    return vector3_new(
        v1[1] - v2[1],
        v1[2] - v2[2],
        v1[3] - v2[3]
    )
end

local function vector3_mul(l, r)
	local v = nil
	local k = nil
	
	if type(l) == 'number' then
		k = l
		v = r
	else
		k = r
		v = l
	end

    return vector3_new(
        v[1]*k,
        v[2]*k,
        v[3]*k
    )
end

local function vector3_equal(v1, v2)
	for i = 1, 3 do
		if v1[i] ~= v2[i] then
			return false
		end
	end
	return true
end

local function vector3_tostring(v)
    return string.format('<%d, %d, %d>', v[1], v[2], v[3])
end

--
-- Metatable overrides
--
vector3.__add = vector3_add
vector3.__sub = vector3_sub
vector3.__mul = vector3_mul
vector3.__eq = vector3_equal
vector3.__tostring = vector3_tostring

-- 
-- Module exports
--
vector3.new = vector3_new
vector3.dot = vector3_dot
vector3.cross = vector3_cross
vector3.mag = vector3_mag
vector3.mag2 = vector3_mag2
vector3.from_points = vector3_from_points
vector3.zero = vector3_zero
vector3.add = vector3_add
vector3.sub = vector3_sub

vector3.equal = vector3_equal
vector3.tostring = vector3_tostring

--
-- Instance dependent functions
--

-- v1 = v1 + v2
function vector3:_add(v)
    self[1] = self[1] + v[1]
    self[2] = self[2] + v[2]
    self[3] = self[3] + v[3]
    return self
end

-- v1 = v1 - v2 
function vector3:_sub(v)
    self[1] = self[1] - v[1]
    self[2] = self[2] - v[2]
    self[3] = self[3] - v[3]
    return self
end

-- v1 = v1 * k
function vector3:_scale(k)
    self[1] = self[1] * k
    self[2] = self[2] * k
    self[3] = self[3] * k
    return self
end

function vector3:set(x, y, z)
    self[1] = x
    self[2] = y
    self[3] = z
end

function vector3:mag()
    return vector3_mag(self)
end

function vector3:dot(v)
    return vector3_dot(self, v)
end

function vector3:cross(v)
    return vector3_cross(self, v)
end

return vector3
