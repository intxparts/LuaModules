local os_ext = require('os_ext')
local path = {}

local _windows_invalid_path_chars = {
	'"',
	'<',
	'>',
	'|',
	'\0'
}

for i = 1, 31 do
	table.insert(_windows_invalid_path_chars, string.char(i))
end

-- returns windows specific cmd string to list all files in the root_directory
-- with the option to also include subdirectories
local function _wincmd_listfiles(root_directory, include_subdirectories)
	-- /b  removes header/extraneous information
	-- /a-d  defines usage of attribute -d (anything not a directory)
	local command = string.format('dir "%s" /b /a-d', root_directory)
	if include_subdirectories then
		command = command .. ' /s'
	end
	return command
end

local function _unixcmd_listfiles(root_directory, include_subdirectories)
	local depth = ''
	if not include_subdirectories then
		depth = '-maxdepth 1'
	end
	local command = string.format('find "%s" "%s" -type f', root_directory, depth)
	return command
end

-- returns windows specific cmd string to list all directories in the root_directory
-- with the option to also include subdirectories
local function _wincmd_listdir(root_directory, include_subdirectories)
	-- /b  removes header/extraneous information
	-- /ad  defines usage of attribute directory
	local command = string.format('dir "%s" /b /ad', root_directory)
	if include_subdirectories then
		command = command .. ' /s'
	end
	return command
end

local function _unixcmd_listdir(root_directory, include_subdirectories)
	local depth = ''
	if not include_subdirectories then
		depth = '-maxdepth 1'
	end
	local command = string.format('find "%s" "%s" -type d', root_directory, depth)
	return command
end

-- returns path string of the current (present) working directory
function path.get_cwd()
	local result = nil
	if os_ext.is_windows then
		result = os_ext.run_command('cd')
	else
		result = os_ext.run_command('pwd')
	end
	return result[1]
end

-- returns whether the target_path exists or not
function path.exists(target_path)
	assert(type(target_path) == 'string')
	local result = nil
	if os_ext.is_windows then
		result = os_ext.run_command(string.format('if exist "%s" (echo true) else (echo false)', target_path))[1] == 'true'
	else
		result = os_ext.run_command(string.format('if test -f "%s"; then echo true; else echo false; fi', target_path))[1] == 'true' or
			os_ext.run_command(string.format('if test -d "%s"; then echo true; else echo false; fi', target_path))[1] == 'true'
	end
	return result
end

-- need to potentially add filtering
function path.list_files(root_directory, include_subdirectories)
	assert(type(root_directory) == 'string')
	assert(path.exists(root_directory), 'directory does not exist')

	local command = nil
	if os_ext.is_windows then
		command = _wincmd_listfiles(root_directory, include_subdirectories)
	else
		command = _unixcmd_listfiles(root_directory, include_subdirectories)
	end
	return os_ext.run_command(command)
end

-- need to potentially add filtering
function path.list_dir(root_directory, include_subdirectories)
	assert(type(root_directory), 'string')
	assert(path.exists(root_directory), 'directory does not exist')

	local command = nil
	if os_ext.is_windows then
		command = _wincmd_listdir(root_directory, include_subdirectories)
	else
		command = _unixcmd_listdir(root_directory, include_subdirectories)
	end
	return os_ext.run_command(command)
end

local function _has_invalid_chars(str)
	local char = nil
	if os_ext.is_windows then
		for i = 1, string.len(str) do
			char = str:sub(i, i)
			for _, c in pairs(_windows_invalid_path_chars) do
				if char == c then
					return true
				end
			end
		end 
	else
		-- TODO add linux
		assert(true == false)
	end
	return false
end

--[[
function path.combine(...)
	assert(#arg > 0)
	local result = ''
	for i = 1, #arg do
		assert(arg[i] ~= nil)
		assert(type(arg[i] == 'string'))
		assert(string.len(arg[i]) > 0)
		assert(!_has_invalid_chars(arg[i]), string.format('argument %d, %s', i, arg[i]))
		result = string.format('%s%s%s', result, os_ext.path_separator, arg[i])
	end
	return result
end
--]]

return path

