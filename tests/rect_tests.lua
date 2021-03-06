package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local ut = require('utest')
local rect = require('rect')

ut:group('rect.new(x [int], y [int], w [int], h [int]) -> [rect]', function()

	ut:test('rect origin is top-left', function()
		local box = rect.new(0, 0, 10, 20)
		assert(box.x == 0)
		assert(box.y == 0)
		assert(box.right == 10)
		assert(box.left == 0)
		assert(box.top == 0)
		assert(box.bottom == 20)
	end)

	ut:test('negative width not permitted', function()
		local result, message = pcall(function() local r = rect.new(0, 0, -10, 20) end)
		assert(result == false)
	end)

	ut:test('negative height not permitted', function()
		local result, message = pcall(function() local r = rect.new(0, 0, 10, -20) end)
		assert(result == false)
	end)

end)

ut:group('rect:set(x [int], y [int], w [int], h [int]) ->', function()

	ut:test('properties updated', function()
		local r = rect.new(0, 0, 10, 10)
		r:set(10, 10, 5, 5)
		assert(r.x == 10)
		assert(r.y == 10)
		assert(r.right == 15)
		assert(r.left == 10)
		assert(r.top == 10)
		assert(r.bottom == 15)
	end)

	ut:test('negative width not permitted', function()
		local r = rect.new(0, 0, 10, 10)
		local result, message = pcall(function() r:set(0, 0, -10, 20) end)
		assert(result == false)
	end)

	ut:test('negative height not permitted', function()
		local r = rect.new(0, 0, 10, 10)
		local result, message = pcall(function() r:set(0, 0, 10, -20) end)
		assert(result == false)
	end)

end)

ut:group('rect:set_height(h [int]) ->', function()
	ut:test('negative height not permitted', function()
		local r = rect.new(0, 0, 10, 10)
		local result, message = pcall(function() r:set_height(-10) end)
		assert(result == false)
	end)

	ut:test('height and bottom updated', function()
		local r = rect.new(10, 10, 10, 10)
		r:set_height(20)
		assert(r.h == 20)
		assert(r.y == 10)
		assert(r.top == 10)
		assert(r.bottom == 30)
	end)
end)

ut:group('rect:set_width(w [int]) ->', function()
	ut:test('negative width not permitted', function()
		local r = rect.new(10, 10, 10, 10)
		local result, message = pcall(function() r:set_width(-10) end)
		assert(result == false)
	end)

	ut:test('width and right updated', function()
		local r = rect.new(10, 10, 10, 10)
		r:set_width(20)
		assert(r.w == 20)
		assert(r.x == 10)
		assert(r.right == 30)
		assert(r.left == 10)
	end)
end)

ut:group('rect:set_x(x [int]) ->', function()
	ut:test('x, left, right updated', function()
		local r = rect.new(10, 10, 10, 10)
		r:set_x(20)
		assert(r.x == 20)
		assert(r.y == 10)
		assert(r.w == 10)
		assert(r.h == 10)
		assert(r.left == 20)
		assert(r.right == 30)
		assert(r.top == 10)
		assert(r.bottom == 20)
	end)
end)

ut:group('rect:set_y(y [int]) ->', function()
	ut:test('y, top, bottom updated', function()
		local r = rect.new(10, 10, 10, 10)
		r:set_y(20)
		assert(r.x == 10)
		assert(r.y == 20)
		assert(r.w == 10)
		assert(r.h == 10)
		assert(r.left == 10)
		assert(r.right == 20)
		assert(r.top == 20)
		assert(r.bottom == 30)
	end)
end)

ut:group('rect:set_top(t [int]) ->', function()
	ut:test('y, top, bottom updated', function()
		local r = rect.new(10, 10, 10, 10)
		r:set_top(20)
		assert(r.x == 10)
		assert(r.y == 20)
		assert(r.w == 10)
		assert(r.h == 10)
		assert(r.left == 10)
		assert(r.right == 20)
		assert(r.top == 20)
		assert(r.bottom == 30)
	end)
end)

ut:group('rect:set_bottom(b [int]) ->', function()
	ut:test('y, top, bottom updated', function()
		local r = rect.new(10, 10, 10, 10)
		r:set_bottom(30)
		assert(r.x == 10)
		assert(r.y == 20)
		assert(r.w == 10)
		assert(r.h == 10)
		assert(r.left == 10)
		assert(r.right == 20)
		assert(r.top == 20)
		assert(r.bottom == 30)
	end)
end)

ut:group('rect:copy() -> [rect]', function()
	ut:test('same data, different object', function()
		local box1 = rect.new(0, 0, 10, 20)
		local box2 = box1:copy()
		assert(box1.x == box2.x and box1.y == box2.y)
		assert(box1.w == box2.w and box2.h == box2.h)
		assert(box1.left == box2.left and box1.right == box2.right)
		assert(box1.top == box2.top and box1.bottom == box2.bottom)
		assert(box1 ~= box2)
		assert(getmetatable(box1) == getmetatable(box2))
	end)
end)

ut:group('rect:contains_point(x [int], y [int]) -> [boolean]', function()
	local box1 = rect.new(0, 0, 10, 10)

	ut:test('boundary point - corner', function()
		assert(box1:contains_point(0, 0))
	end)

	ut:test('boundary point - edge', function()
		assert(box1:contains_point(2, 10))
	end)

	ut:test('external point', function()
		assert(not box1:contains_point(11, 10))
	end)

	ut:test('internal point', function()
		assert(box1:contains_point(5, 5))
	end)

end)

ut:group('rect:strictly_contains_point(x [int], y [int]) -> [boolean]', function()
	local box1 = rect.new(0, 0, 10, 10)

	ut:test('boundary point - corner', function()
		assert(not box1:strictly_contains_point(0, 0))
	end)

	ut:test('boundary point - edge', function()
		assert(not box1:strictly_contains_point(2, 10))
	end)

	ut:test('external point', function()
		assert(not box1:strictly_contains_point(11, 10))
	end)

	ut:test('internal point', function()
		assert(box1:strictly_contains_point(5, 5))
	end)

end)

ut:group('rect:has_y_collision(r [rect]) -> [boolean]', function()

	local box1 = rect.new(0, 0, 10, 10)
	ut:test('boundary line collision - top', function()
		assert(box1:has_y_collision(rect.new(2, -5, 5, 5)))
	end)

	ut:test('boundary line collision - bottom', function()
		assert(box1:has_y_collision(rect.new(0, 10, 5, 5)))
	end)

	ut:test('rect.top between other_rect y bounds', function()
		assert(box1:has_y_collision(rect.new(0, -5, 10, 10)))
	end)

	ut:test('rect.bottom between other_rect y bounds', function()
		assert(box1:has_y_collision(rect.new(0, 5, 10, 10)))
	end)

	ut:test('rect completely contained in other_rect y bounds', function()
		assert(box1:has_y_collision(rect.new(-1, -1, 20, 20)))
	end)

	ut:test('other_rect completely contained in y bounds', function()
		assert(box1:has_y_collision(rect.new(11, 1, 3, 3)))
	end)

	ut:test('other_rect outside y bounds', function()
		assert(not box1:has_y_collision(rect.new(11, 11, 10, 10)))
	end)
end)

ut:group('rect:has_x_collision(r [rect]) -> [boolean]', function()
	local box1 = rect.new(0, 0, 10, 10)
	ut:test('boundary line collision - left', function()
		assert(box1:has_x_collision(rect.new(-10, 2, 10, 5)))
	end)

	ut:test('boundary line collision - right', function()
		assert(box1:has_x_collision(rect.new(10, 2, 5, 5)))
	end)

	ut:test('rect.left between other_rect x bounds', function()
		assert(box1:has_x_collision(rect.new(-5, 2, 10, 10)))
	end)

	ut:test('rect.right between other_rect x bounds', function()
		assert(box1:has_x_collision(rect.new(5, 2, 10, 10)))
	end)

	ut:test('rect compeletely contained in other_rect x bounds', function()
		assert(box1:has_x_collision(rect.new(-1, -1, 20, 20)))
	end)

	ut:test('other_rect completely contained in x bounds', function()
		assert(box1:has_x_collision(rect.new(1, 11, 3, 3)))
	end)

	ut:test('other_rect outside x bounds', function()
		assert(not box1:has_x_collision(rect.new(11, 11, 10, 10)))
	end)
end)

ut:group('rect:collide(r [rect]) -> [boolean]', function()
	local box1 = rect.new(10, 10, 10, 10)
	local collision_test = function(description, other_rect, expected)
		return {desc=description, other_rect=other_rect, expected=expected}
	end
	local run = function(tests)
		for _, test in pairs(tests) do
			ut:test(test.desc, function()
				assert(box1:collide(test.other_rect) == test.expected)
			end)
		end
	end
	local has_collision = true
	local no_collision = false
	local collision_tests = {
		collision_test('top-left corner point collision', rect.new(0, 0, 10, 10), has_collision),
		collision_test('top-left corner point + top edge collision', rect.new(0, 0, 20, 10), has_collision),
		collision_test('top edge only collision', rect.new(12, 0, 5, 10), has_collision),
		collision_test('top edge contained by other_rect', rect.new(8, 0, 20, 15), has_collision),
		collision_test('top edge overlap', rect.new(12, 5, 5, 10), has_collision),
		collision_test('top-right corner point collision', rect.new(20, 0, 10, 10), has_collision),
		collision_test('top-right corner point + top edge collision', rect.new(15, 0, 20, 10), has_collision),
		collision_test('right edge + top-right corner point', rect.new(10, 5, 10, 10), has_collision),
		collision_test('right edge only collision', rect.new(10, 12, 5, 5), has_collision),
		collision_test('right edge contained by other_rect', rect.new(10, 5, 30, 30), has_collision),
		collision_test('right edge overlap', rect.new(5, 12, 10, 5), has_collision),
		collision_test('bottom-right corner point + right edge collision', rect.new(10, 15, 10, 10), has_collision),
		collision_test('bottom-right corner point collision', rect.new(20, 20, 10, 10), has_collision),
		collision_test('bottom-right corner point contained in other_rect', rect.new(15, 15, 10, 10), has_collision),
		collision_test('bottom-right corner point + bottom edge collision', rect.new(15, 20, 10, 10), has_collision),
		collision_test('bottom edge only collision', rect.new(12, 20, 5, 5), has_collision),
		collision_test('bottom edge overlap', rect.new(12, 18, 5, 5), has_collision),
		collision_test('bottom edge contained in other_rect', rect.new(5, 15, 20, 20), has_collision),
		collision_test('bottom-left corner point + bottom edge collision', rect.new(5, 20, 10, 10), has_collision),
		collision_test('bottom-left corner point contained in other_rect', rect.new(5, 15, 10, 10), has_collision),
		collision_test('bottom-left corner point collision', rect.new(5, 10, 5, 5), has_collision),
		collision_test('bottom-left corner point + left edge collision', rect.new(5, 15, 5, 10), has_collision),
		collision_test('left edge collision only', rect.new(5, 12, 5, 5), has_collision),
		collision_test('left edge overlap', rect.new(5, 12, 10, 5), has_collision),
		collision_test('left edge contained in other_rect', rect.new(5, 5, 20, 20), has_collision),
		collision_test('rect contained in other_rect', rect.new(0, 0, 30, 30), has_collision),
		collision_test('rect contains other_rect', rect.new(12, 12, 5, 5), has_collision),
		collision_test('outside left-top overlap', rect.new(2, 2, 5, 10), no_collision),
		collision_test('outside top-left overlap', rect.new(2, 2, 10, 5), no_collision),
		collision_test('outside top - width contains rect', rect.new(2, 2, 20, 5), no_collision),
		collision_test('outside top - width contained in rect', rect.new(12, 2, 5, 5), no_collision),
		collision_test('outside top-right overlap', rect.new(15, 2, 10, 5), no_collision),
		collision_test('outside top-right corner', rect.new(21, 0, 10, 9), no_collision),
		collision_test('outside right-top overlap', rect.new(21, 5, 10, 10), no_collision),
		collision_test('outside right - height contains rect', rect.new(21, 5, 20, 20), no_collision),
		collision_test('outside right - height contained in rect', rect.new(21, 12, 5, 5), no_collision),
		collision_test('outside right-bottom overlap', rect.new(21, 15, 10, 10), no_collision),
		collision_test('outside bottom-right corner', rect.new(21, 21, 10, 10), no_collision),
		collision_test('outside bottom-right overlap', rect.new(15, 21, 10, 10), no_collision),
		collision_test('outside bottom - width contains rect', rect.new(8, 21, 20, 10), no_collision),
		collision_test('outside bottom - width contained in rect', rect.new(12, 21, 5, 5), no_collision),
		collision_test('outside bottom-left overlap', rect.new(5, 21, 10, 10), no_collision),
		collision_test('outside bottom-left corner', rect.new(0, 21, 9, 10), no_collision),
		collision_test('outside left-bottom overlap', rect.new(2, 15, 5, 10), no_collision),
		collision_test('outside left - height contains rect', rect.new(0, 0, 5, 30), no_collision),
		collision_test('outside left - height contained in rect', rect.new(0, 12, 5, 5), no_collision),
		collision_test('outside top-left corner', rect.new(0, 0, 9, 9), no_collision)
	}

	run(collision_tests)
end)
