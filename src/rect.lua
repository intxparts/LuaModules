--[[
-- rect represents a rectangle defined by:
--      - top-left point (x, y)
--      - width (w)
--      - height (h)
--
--                 w
--      (x, y) --------- <- top
--             |       |
--             |       | h
--             |       |
--             --------- <- bottom
--
--             ^       ^
--             |       |
--            left    right
--
-- Note: rect follows the paradigm:
--          y + h = bottom
--          x + w = right
--]]

local rect = {}
rect.__index = rect

function rect.new(x, y, w, h)
    assert(w >= 0)
    assert(h >= 0)
    local r = {x=x,y=y,w=w,h=h}
    r.top = y
    r.bottom = y + h
    r.left = x
    r.right = x + w
    setmetatable(r, rect)
    return r
end

function rect:copy()
    return rect.new(self.x, self.y, self.w, self.h)
end

function rect:set(x, y, w, h)
    assert(w >= 0)
    assert(h >= 0)
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.right = x + w
    self.left = x
    self.top = y
    self.bottom = y + h
end

function rect:set_height(h)
    assert(h >= 0)
    self.h = h
    self.bottom = self.y + h
end

function rect:set_width(w)
    assert(w >= 0)
    self.w = w
    self.right = self.x + w
end

function rect:set_x(x)
    self.x = x
    self.left = x
    self.right = x + self.w
end

function rect:set_y(y)
    self.y = y
    self.top = y
    self.bottom = y + self.h
end

function rect:set_left(v)
    self.left = v
    self.x = v
    self.right = x + self.w
end

function rect:set_right(v)
    local pos = v - self.w
    self.right = v
    self.left = pos
    self.x = pos
end

function rect:set_top(v)
    self.y = v
    self.top = v
    self.bottom = v + self.h
end

function rect:set_bottom(v)
    local pos = v - self.h
    self.bottom = v
    self.top = pos
    self.y = pos
end

function rect:contains_point(x, y)
    return (self.left <= x and x <= self.right) and
           (self.top <= y and y <= self.bottom)
end

-- ignore points on the border
function rect:strictly_contains_point(x, y)
    return (self.left < x and x < self.right) and
           (self.top < y and y < self.bottom)
end

function rect:has_y_collision(other_rect)
    local self_bottom_between_y_bounds = other_rect.top <= self.bottom and self.bottom <= other_rect.bottom
    local self_top_between_y_bounds = other_rect.top <= self.top and self.top <= other_rect.bottom
    local other_bottom_between_y_bounds = self.top <= other_rect.bottom and other_rect.bottom <= self.bottom
    local other_top_between_y_bounds = self.top <= other_rect.top and other_rect.top <= self.bottom
    local has_y_col = self_top_between_y_bounds or self_bottom_between_y_bounds or other_bottom_between_y_bounds or other_top_between_y_bounds
    return has_y_col
end

function rect:has_x_collision(other_rect)
    local self_left_between_x_bounds = other_rect.left <= self.left and self.left <= other_rect.right
    local self_right_between_x_bounds = other_rect.left <= self.right and self.right <= other_rect.right
    local other_left_between_x_bounds = self.left <= other_rect.left and other_rect.left <= self.right
    local other_right_between_x_bounds = self.left <= other_rect.right and other_rect.right <= self.right
    local has_x_col = self_left_between_x_bounds or self_right_between_x_bounds or other_left_between_x_bounds or other_right_between_x_bounds
    return has_x_col
end

function rect:collide(other_rect)
    return self:has_x_collision(other_rect) and self:has_y_collision(other_rect)
end

return rect
