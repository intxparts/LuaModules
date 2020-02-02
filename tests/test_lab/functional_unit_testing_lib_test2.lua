package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local test_lab = require('test_lab')

test_lab:group('group 1 ->', function()
	test_lab:test('test 1', function()

	end)

	test_lab:test('test 2', function()

	end)
end)

test_lab:group('group 2 ->', function()
	test_lab:test('test 1', function()

	end)

	test_lab:test('test 2', function()

	end)
end)
