local os_ext = require('os_ext')
local path = {}

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
        result = os_ext.run_command(string.format('if exist "%s" (echo true) else (echo false)', target_path)) 
    else
        result = os_ext.run_command(string.format('if test "%s" then echo true; else echo false; fi', target_path))
    end
    return result[1] == 'true'
end

-- root_directory must be absolute path currently
function path.list_files(root_directory, include_subdirectories)
    assert(type(root_directory) == 'string')
    assert(path.exists(root_directory), 'directory does not exist')
    
    local command = nil
    if os_ext.is_windows then
        command = _wincmd_listfiles(root_directory, include_subdirectories)
    else
        -- TODO: add linux command
        assert(true == false)
    end
    return os_ext.run_command(command) 
end

-- root_directory must be absolute path currently
function path.list_dir(root_directory, include_subdirectories)
    assert(type(root_directory), 'string')
    assert(path.exists(root_directory), 'directory does not exist')

    local command = nil
    if os_ext.is_windows then
        command = _wincmd_listdir(root_directory, include_subdirectories)
    else
        -- TODO: add linux command
        assert(true == false)
    end
    return os_ext.run_command(command)
end

return path

