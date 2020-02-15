package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local ut = require('utest')
local path = require('path')
local ose = require('os_ext')


ut:group('path.exists(target_path [string]) -> [bool]', function()
	if ose.is_windows then
		ut:test('valid directory', function()
			assert(path.exists('C:\\Windows\\'))
		end)
		ut:test('invalid directory', function()
			assert(not path.exists('C:\\ShouldNotExist\\'))
		end)
		ut:test('valid file', function()
			assert(path.exists('C:\\Windows\\System32\\cmd.exe'))
		end)
		ut:test('invalid file', function()
			assert(not path.exists('C:\\Windows\\ShouldNotExist.dat'))
		end)
	elseif ose.is_unix then
		ut:test('valid directory', function()
			assert(path.exists('/bin/'))
		end)
		ut:test('invalid directory', function()
			assert(not path.exists('/ShouldNotExist/'))
		end)
		ut:test('valid file', function()
			assert(path.exists('/bin/ls'))
		end)
		ut:test('invalid file', function()
			assert(not path.exists('/bin/ShouldNotExist'))
		end)
	end
end)