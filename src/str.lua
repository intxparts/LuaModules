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
    local str_table = {}
    local i = 0
    while i < n do
        table.insert(str_table, s)
        i = i + 1
    end
    local result = table.concat(str_table, sep)
    return result
end

function str.join(...)
    return table.concat(arg)
end

return str
