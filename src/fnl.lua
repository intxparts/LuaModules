local fnl = {}

local function fnl_clone(t)
    assert(type(t) == 'table')
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = v 
    end
    return copy
end

local function fnl_map(t, fn)
    assert(type(t) == 'table')
    assert(type(fn) == 'function')

    local r = {}
    for k, v in pairs(t) do
        r[k] = fn(v)
    end
    return r
end

local function fnl_filter(t, fn)
    assert(type(t) == 'table')
    assert(type(fn) == 'function')

    local r = {}
    for k, v in pairs(t) do
        if fn(k, v) then 
            r[k] = v 
        end
    end
    return r
end

local function fnl_any(t, fn)
    assert(type(t) == 'table')
    assert(type(fn) == 'function')
    
    for k, v in pairs(t) do
        if fn(k, v) then
            return true
        end
    end

    return false
end

local function fnl_all(t, fn)
    assert(type(t) == 'table')
    assert(type(fn) == 'function')

    for k, v in pairs(t) do
        if not fn(k, v) then
            return false
        end
    end
    return true
end

local function fnl_reduce(t, fn, first)
    assert(type(t) == 'table')
    assert(type(fn) == 'function')

    local acc = first
    local initial_value_given = first and true or false
    for _, v in pairs(t) do
        if initial_value_given then
            acc = fn(acc, v)
        else
            acc = v
        end
    end
    return acc
end

local function fnl_contains_value(t, value)
    assert(type(t) == 'table')

    for _, v in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

local function fnl_contains_key(t, key)
    assert(type(t) == 'table')

    for k, _ in pairs(t) do
        if k == key then
            return true
        end
    end
    return false
end

local function fnl_count(t, fn)
    assert(type(t) == 'table')
    assert(type(fn) == 'function')

    local count = 0
    for k, v in pairs(t) do
        if fn(k, v) then
            count = count + 1
        end
    end
    return count
end

fnl.filter = fnl_filter
fnl.all = fnl_all
fnl.any = fnl_any
fnl.map = fnl_map
fnl.clone = fnl_clone
fnl.reduce = fnl_reduce
fnl.count = fnl_count
fnl.contains_key = fnl_contains_key
fnl.contains_value = fnl_contains_value

return fnl
