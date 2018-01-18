local os_ext = {}
os_ext.platforms = { unix = 'unix', windows = 'windows' }

local _separator_platform_table = { ['/'] = os_ext.platforms.unix, ['\\'] = os_ext.platforms.windows }

function os_ext.get_path_separator()
    return package.config:sub(1,1)
end

function os_ext.get_platform()
    return _separator_platform_table[os_ext.get_path_separator()]
end

return os_ext
