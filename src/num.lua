local num = {}

function num.is_integer(n)
    return type(n) == 'number' and math.floor(n) == n
end

return num
