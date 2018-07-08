local str = {}

function str.to_bool(s)
    if type(s) ~= 'string' then
        return nil
    end
    if s == 'false' then
        return false
    elseif s == 'true' then
        return true
    else
        return nil
    end
end

function str.to_integer(s)
    local number = tonumber(s)
    if number == nil then
        return nil
    end

    return math.floor(number)
end

function str.rep(s, n, sep)
    assert(type(s) == 'string')
    assert(type(n) == 'number')
    if n <= 1 then
        return s
    end

    local str_table = {}
    local i = 0
    while i < n do
        table.insert(str_table, s)
        i = i + 1
    end
    local result = table.concat(str_table, sep)
    return result
end

function str.join(t, sep)
    assert(type(t) == 'table')
    local str_table = {}
    for _, v in ipairs(t) do
        if type(v) == 'string' then
            table.insert(str_table, v)
        else
            table.insert(str_table, tostring(v))
        end
    end

    local sep_str = nil
    if sep == nil then
        sep_str = ''
    elseif type(sep) == 'string' then
        sep_str = sep
    else
        sep_str = tostring(sep)
    end
    return table.concat(str_table, sep_str)
end

return str
