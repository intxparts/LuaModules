local vec3 = {}
vec3.__index = vec3

function vec3.new(x, y, z)
    local v = { [1]=x or 0, [2]=y or 0, [3]=z or 0}
    setmetatable(v, vec3)
    return v
end

function vec3.zero()
    return vec3.new(0, 0, 0)
end

function vec3.from_points(p1, p2)
    return vec3.new(
        p2[1] - p1[1],
        p2[2] - p1[2],
        p2[3] - p1[3]
    )
end

function vec3.dot(v1, v2)
    return v1[1]*v2[1] + v1[2]*v2[2] + v1[3]*v2[3]
end

function vec3.mag2(v)
    return vec3.dot(v, v)
end

function vec3.mag(v)
    return math.sqrt(vec3.mag2(v))
end

function vec3.cross(v1, v2)
    return vec3.new(
        v1[2]*v2[3] - v1[3]*v2[2],
        v1[3]*v2[1] - v1[1]*v2[3],
        v1[1]*v2[2] - v1[2]*v2[1]
    )
end

function vec3.__add(v1, v2)
    return vec3.new(
        v1[1] + v2[1],
        v1[2] + v2[2],
        v1[3] + v2[3]
    )
end

function vec3.__sub(v1, v2)
    return vec3.new(
        v1[1] - v2[1],
        v1[2] - v2[2],
        v1[3] - v2[3]
    )
end

function vec3.__mul(l, r)
	local v = nil
	local k = nil
	
	if type(l) == 'number' then
		k = l
		v = r
	else
		k = r
		v = l
	end

    return vec3.new(
        v[1]*k,
        v[2]*k,
        v[3]*k
    )
end

function vec3.__eq(v1, v2)
	for i = 1, 3 do
		if v1[i] ~= v2[i] then
			return false
		end
	end
	return true
end

function vec3.__tostring(v)
    return string.format('<%d, %d, %d>', v[1], v[2], v[3])
end

vec3.equals = vec3.__eq
vec3.tostring = vec3.__tostring

--
-- Instance dependent functions
--

-- v1 = v1 + v2
function vec3:_add(v)
    self[1] = self[1] + v[1]
    self[2] = self[2] + v[2]
    self[3] = self[3] + v[3]
    return self
end

-- v1 = v1 - v2 
function vec3:_sub(v)
    self[1] = self[1] - v[1]
    self[2] = self[2] - v[2]
    self[3] = self[3] - v[3]
    return self
end

-- v1 = v1 * k
function vec3:_scale(k)
    self[1] = self[1] * k
    self[2] = self[2] * k
    self[3] = self[3] * k
    return self
end

function vec3:set(x, y, z)
    self[1] = x
    self[2] = y
    self[3] = z
end

function vec3:_mag()
    return vec3.mag(self)
end

function vec3:_dot(v)
    return vec3.dot(self, v)
end

function vec3:_cross(v)
    return vec3.cross(self, v)
end

return vec3
