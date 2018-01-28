local os_ext = require('os_ext')
local platform = os_ext.get_platform()

local path = {}

local function _get_windows_command_list_files(root_directory, include_subdirectories)
    -- /b  removes header/extraneous information
    -- /a-d  defines usage of attribute -d (anything not a directory)
    local command = string.format('dir "%s" /b /a-d', root_directory)
    if include_subdirectories then
        command = command .. ' /s'
    end
    return command 
end

local function _get_windows_command_list_directories(root_directory, include_subdirectories)
    -- /b  removes header/extraneous information
    -- /ad  defines usage of attribute directory
    local command = string.format('dir "%s" /b /ad', root_directory)
    if include_subdirectories then
        command = command .. '/s'
    end
    return command
end

local function _run_command(command)
    local idx = 0
    local results = {}
    local pfile = io.popen(command)
    for line in pfile:lines() do
        idx = idx + 1
        results[idx] = line
    end
    pfile:close()
    return results
end

function path.get_cwd()
    local result = nil
    if platform == os_ext.platforms.windows then
        result = _run_command('cd')
    else
        result = _run_command('pwd')
    end
    return result[1]
end

-- root_directory must be absolute path currently
function path.list_files(root_directory, include_subdirectories)
    assert(type(root_directory), 'string')
    local command = nil
    if platform == os_ext.platforms.windows then
        command = _get_windows_command_list_files(root_directory, include_subdirectories)
    else
        -- TODO: add linux command
        assert(true == false)
    end
    return _run_command(command) 
end

-- root_directory must be absolute path currently
function path.list_directories(root_directory, include_subdirectories)
    assert(type(root_directory), 'string')
    local command = nil
    if platform == os_ext.platforms.windows then
        command = _get_windows_command_list_directories(root_directory, include_subdirectories)
    else
        -- TODO: add linux command
        assert(true == false)
    end
    return _run_command(command)
end

return path
