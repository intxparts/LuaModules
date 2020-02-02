package.path = package.path .. '; ..\\..\\?.lua; ..\\..\\src\\?.lua'

local test_lab = require('test_lab')

test_lab:group('nothing', function()
	test_lab:test('temporary', function()
		print("temp test")
	end)
end)
