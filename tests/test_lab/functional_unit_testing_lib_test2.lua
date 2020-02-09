package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local ut = require('utest')

ut:group('group 1 ->', function()
	ut:test('test 1', function()

	end)

	ut:test('test 2', function()

	end)
end)

ut:group('group 2 ->', function()
	ut:test('test 1', function()

	end)

	ut:test('test 2', function()

	end)
end)
