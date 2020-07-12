package.path = package.path .. '; ..\\..\\?.lua; ..\\..\\src\\?.lua'

local ut = require('utest')

ut:group('nothing', function()
	ut:test('temporary', function()
		print("temp test")
	end)
end, {'temp'})
