local ose = require('os_ext')
local dir = {}

function dir.create(dir_path)
	local result, output, err_code, err_msg = ose.run_command(string.format('mkdir %q', dir_path))
	return result, err_msg
end

function dir.copy(source_dir, dest_dir)
	local result = false
	local output = nil
	local err_code = 0
	local err_msg = nil
	if ose.is_windows then
		result, output, err_code, err_msg = ose.run_command(string.format('xcopy /E /Q /C /Y /R /I %q %q', source_dir, dest_dir))
	else
		result, output, err_code, err_msg = ose.run_command(string.format('cp -r %q %q', source_dir, dest_dir))
	end
	return result, err_msg
end

function dir.delete(dir_path)
	local result = false
	local output = nil
	local err_code = 0
	local err_msg = nil
	if ose.is_windows then
		result, output, err_code, err_msg = ose.run_command(string.format('rmdir /S /Q %q', dir_path))
	else
		result, output, err_code, err_msg = ose.run_command(string.format('rm -rfd %q', dir_path))
	end
	return result, err_msg
end

return dir
