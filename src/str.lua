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

return str
