local ose = require('os_ext')
local path = require('path')
local file = {}

function file.exists(file_path)
	return path.exists(file_path)
end

function file.copy(source_file_path, dest_file_path, overwrite)
	if not overwrite and path.exists(dest_file_path) then
		return false, string.format('file exists: %s', dest_file_path)
	end
	
	local result = false
	local output = nil
	local err_code = 0
	local err_msg = nil
	if ose.is_windows then
		result, output, err_code, err_msg = ose.run_command(string.format('copy /Y %q %q', source_file_path, dest_file_path))
	else
		result, output, err_code, err_msg = ose.run_command(string.format('cp -f %q %q', source_file_path, dest_file_path))
	end

	return result, err_msg
end

function file.delete(file_path)
	local result = false
	local output = nil
	local err_code = 0
	local err_msg = nil 
	if ose.is_windows then
		-- del cannot handle \\ in the filepath which is required for the lua string escaping.
		-- del also cannot handle / being used instead of \. 
		-- result, output, err_code, err_msg = ose.run_command(string.format('del /F /Q "%q"', file_path))
		
		result, output, err_code, err_msg = ose.run_command(string.format('powershell "Remove-Item %q -Force"', file_path))
	else
		result, output, err_code, err_msg = ose.run_command(string.format('rm -f %q', file_path))
	end

	return result, err_msg
end

return file
