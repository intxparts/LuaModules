package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local ut = require('utest')
local path = require('path')
local ose = require('os_ext')
local tbl = require('tbl')


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
end, {'integration'})


ut:group('path.list_files(root_directory [string], include_subdirectories [bool]) -> [table<string>]', function()
	if ose.is_windows then
		
		ut:test('valid root directory', function()
			local files = path.list_files('C:\\Windows\\System32\\', false)
			assert(tbl.contains_value(files, 'C:\\Windows\\System32\\cmd.exe'))
		end)
		
		ut:test('valid root directory searching subdirectories', function()
			local files = path.list_files('C:\\Windows\\System32\\WindowsPowerShell\\', true)
			assert(tbl.contains_value(files, 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe'))
		end)
		
		ut:test('invalid root directory raises an error', function()
			local success, err = pcall(function()
				local files = path.list_files('C:\\ShouldNotExist\\', false)
			end)
			assert(not success)
			assert(string.find(err, 'directory "C:\\ShouldNotExist\\" does not exist') ~= nil)
		end)
		
	elseif ose.is_unix then
		
		ut:test('valid root directory', function()
			local files = path.list_files('/bin/', false)
			assert(tbl.contains_value(files, '/bin/ls'))
		end)
		
		ut:test('valid root directory searching subdirectories', function()
			local files = path.list_files('/lib/', true)
			assert(tbl.contains_value(files, '/lib/systemd/systemd'))
		end)
		
		ut:test('invalid root directory raises an error', function()
			local success, err = pcall(function()
				local files = path.list_files('/ShouldNotExist', false)
			end)
			assert(not success)
			assert(string.find(err, 'directory does not exist') ~= nil)
		end)
	end
end, {'integration'})


--[[
ut:group('path.list_dir(root_directory [string], include_subdirectories[bool]) -> [table<string>]', function()
	if ose.is_windows then
		ut:test('', function()
			
		end)
	
	elseif ose.is_unix then
	
	end

end, {'integration'})]]--

ut:group('path.get_filename(filepath [string]) -> [string]', function()
	if ose.is_windows then

		ut:test('filepath must be a string: nil', function()
			local filepath = nil
			local result, err = pcall(function() return path.get_filename(filepath) end)
			assert(result == false)
		end)

		ut:test('empty string', function()
			local filepath = ''
			local result = path.get_filename(filepath)
			assert(result == '')
		end)

		ut:test('.\\hello.txt -> hello.txt', function()
			local filepath = '.\\hello.txt'
			local result = path.get_filename(filepath)
			assert(result == 'hello.txt')
		end)

		ut:test('InvalidPath//\\myFile.lua -> myFile.lua', function()
			local filepath = 'InvalidPath//\\myFile.lua'
			local result = path.get_filename(filepath)
			assert(result == 'myFile.lua')
		end)

		ut:test('C:\\test\\world.py -> world.py', function()
			local filepath = 'C:\\test\\world.py'
			local result = path.get_filename(filepath)
			assert(result == 'world.py')
		end)

		ut:test('C://test//world.py -> ""', function()
			local filepath = 'C://test//world.py'
			local result = path.get_filename(filepath)
			assert(result == '')
		end)

		ut:test('//myFile.lua -> ""', function()
			local filepath = '//myFile.lua'
			local result = path.get_filename(filepath)
			assert(result == '')
		end)

	elseif ose.is_unix then

		ut:test('filepath must be a string: nil', function()
			local filepath = nil
			local result, err = pcall(function() return path.get_filename(filepath) end)
			assert(result == false)
		end)

		ut:test('empty string', function()
			local filepath = ''
			local result = path.get_filename(filepath)
			assert(result == '')
		end)

		ut:test('.\\hello.txt -> ""', function()
			local filepath = '.\\hello.txt'
			local result = path.get_filename(filepath)
			assert(result == '')
		end)

		ut:test('InvalidPath//\\myFile.lua -> myFile.lua', function()
			local filepath = 'InvalidPath//\\myFile.lua'
			local result = path.get_filename(filepath)
			assert(result == '\\myFile.lua')
		end)

		ut:test('C:\\test\\world.py -> ""', function()
			local filepath = 'C:\\test\\world.py'
			local result = path.get_filename(filepath)
			assert(result == '')
		end)

		ut:test('C://test//world.py -> world.py', function()
			local filepath = 'C://test//world.py'
			local result = path.get_filename(filepath)
			assert(result == 'world.py')
		end)

		ut:test('//myFile.lua -> myFile.lua', function()
			local filepath = '//myFile.lua'
			local result = path.get_filename(filepath)
			assert(result == 'myFile.lua')
		end)
	end
end, {'integration'})
