local os_ext = {}

os_ext.platforms = { 
    unix = 'unix', 
    windows = 'windows' 
}

os_ext.path_separator = package.config:sub(1, 1)

local _separator_platform_table = { 
    ['/'] = os_ext.platforms.unix, 
    ['\\'] = os_ext.platforms.windows 
}

os_ext.platform = _separator_platform_table[os_ext.path_separator]
os_ext.is_windows = os_ext.platform == os_ext.platforms.windows
os_ext.is_unix = os_ext.platform == os_ext.platforms.unix

-- Returns an output table of an command string being invoked
function os_ext.run_command(command)
    assert(type(command) == 'string')
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

return os_ext

