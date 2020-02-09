package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'
local ut = require('utest')

ut:group('success tests ->', function()
	ut:before_each(function() local i = 0 end)
	ut:after(function() local j = 0 end)

	ut:test('test 1', function()
		assert(1 == 1)
	end)

	ut:test('test 2', function()
		assert(1 ~= 2)
	end)
end)

ut:group('failure tests ->', function()
	ut:before(function() local i = 0 end)
	ut:after_each(function() local j = 0 end)

	ut:test('test 3', function()
		assert(1 == 2, 'expected failure')
	end)

	ut:test('test 4', function()
		assert(1 == 3, 'expected failure')
	end)
end, {'efail'})

