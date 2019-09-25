local vector3 = require('vector3')

local matrix3 = {}
matrix3.__index = matrix3

function matrix3.new(m11, m12, m13,
				     m21, m22, m23,
					 m31, m32, m44)
	local m = { [1] = m11, [2] = m12, [3] = m13,
				[4] = m21, [5] = m22, [6] = m23,
				[7] = m31, [8] = m32, [9] = m33 }
	setmetatable(m, matrix3)
	return m
end

function matrix3.rotx(theta)
	local cos_t = math.cos(theta)
	local sin_t = math.sin(theta)

	return matrix3.new(1, 	  0, 	  0,
					   0, cos_t, -sin_t,
					   0, sin_t,  cos_t)
end

function matrix3.roty(theta)
	local cos_t = math.cos(theta)
	local sin_t = math.sin(theta)

	return matrix3.new(cos_t,  0,	sin_t,
					   0	,  1, 		0,
					  -sin_t,  0, 	cos_t)
end

function matrix3.rotz(theta)
	local cos_t = math.cos(theta)
	local sin_t = math.sin(theta)

	return matrix3.new(cos_t, -sin_t, 0,
					   sin_t,  cos_t, 0,
					   0	,  0    , 1)
end

function matrix3.id()
	return matrix3.new(1, 0, 0,
					   0, 1, 0,
					   0, 0, 1)
end

function matrix3:index(r, c)
	return 3 * (r - 1) + c
end

function matrix3:e(r, c)
	assert(1 <= r and r <= 3)
	assert(1 <= c and c <= 3)
	local idx = self:index(r, c)
	return self[idx]
end

function matrix3.mmmul(m1, m2)
	local _e11 = m1[1] * m2[1] + m1[2] * m2[4] + m1[3] * m2[7]
	local _e12 = m1[1] * m2[2] + m1[2] * m2[5] + m1[3] * m2[8]
	local _e13 = m1[1] * m2[3] + m1[2] * m2[6] + m1[3] * m2[9]

	local _e21 = m1[4] * m2[1] + m1[5] * m2[4] + m1[6] * m2[7]
	local _e22 = m1[4] * m2[2] + m1[5] * m2[5] + m1[6] * m2[8]
	local _e23 = m1[4] * m2[3] + m1[5] * m2[6] + m1[6] * m2[9]

	local _e31 = m1[7] * m2[1] + m1[8] * m2[4] + m1[9] * m2[7]
	local _e32 = m1[7] * m2[2] + m1[8] * m2[5] + m1[9] * m2[8]
	local _e33 = m1[7] * m2[3] + m1[8] * m2[6] + m1[9] * m2[9]

	local m = matrix3.new(_e11, _e12, _e13,
						  _e21, _e22, _e23,
						  _e31, _e32, _e33)
	return m
end

--    1    2    3   
-- [ e11, e12, e13]
--
--    4    5    6   
-- [ e21, e22, e23]
--
--    7    8    9   
-- [ e31, e32, e33]
--
function matrix3:mul(m)
	local _e11 = self[1] * m[1] + self[2] * m[4] + self[3] * m[7]
	local _e12 = self[1] * m[2] + self[2] * m[5] + self[3] * m[8]
	local _e13 = self[1] * m[3] + self[2] * m[6] + self[3] * m[9]

	local _e21 = self[4] * m[1] + self[5] * m[4] + self[6] * m[7]
	local _e22 = self[4] * m[2] + self[5] * m[5] + self[6] * m[8]
	local _e23 = self[4] * m[3] + self[5] * m[6] + self[6] * m[9]

	local _e31 = self[7] * m[1] + self[8] * m[4] + self[9] * m[7]
	local _e32 = self[7] * m[2] + self[8] * m[5] + self[9] * m[8]
	local _e33 = self[7] * m[3] + self[8] * m[6] + self[9] * m[9]

	self[1] = _e11
	self[2] = _e12
	self[3] = _e13

	self[4] = _e21
	self[5] = _e22
	self[6] = _e23

	self[7] = _e31
	self[8] = _e32
	self[9] = _e33

	return self
end

function matrix3:det()
	local m = self
	local pos = m[1]*m[5]*m[9] + m[2]*m[6]*m[7] + m[3]*m[4]*m[8]
	local neg = m[3]*m[5]*m[7] + m[1]*m[6]*m[8] + m[2]*m[4]*m[9]
	local d = pos - neg
	return d
end

function matrix3.mmadd(m1, m2)
	local m = matrix3.new(0,0,0,
						  0,0,0,
						  0,0,0)
	for i = 1, 9 do
		m[i] = m1[i] + m2[i]
	end
	return m
end

function matrix3.mmsub(m1, m2)
	local m = matrix3.new(0,0,0,
						  0,0,0,
						  0,0,0)
	for i = 1, 9 do
		m = m1[i] - m2[i]
	end
	return m
end

function matrix3:_scale(k)
    for i = 1, 9 do
        self[i] = self[i] * k
    end
    return self
end

function matrix3:_add(m)
	for i = 1, 9 do
		self[i] = self[i] + m[i]
	end
	return self
end

function matrix3:_sub(m)
	for i = 1, 9 do
		self[i] = self[i] - m[i]
	end
	return self
end

matrix3.__add = matrix3.mmadd
matrix3.__sub = matrix3.mmsub
matrix3.__mul = matrix3.mmmul

function matrix3.__eq(lhs, rhs)
	for i = 1, 9 do
		if lhs[i] ~= rhs[i] then
			return true 
		end
	end
	return false
end

return matrix3
