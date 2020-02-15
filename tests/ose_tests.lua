package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local ut = require('utest')
local ose = require('os_ext')


ut:group('ose.path_separator', function()
	if ose.is_windows then
		ut:test('windows separator == "\"', function()
			assert(ose.path_separator == '\\')
		end)
	elseif ose.is_unix then
		ut:test('*nix separator == "/"', function()
			assert(ose.path_separator == '/')
		end)
	end
end)
