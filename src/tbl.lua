local tbl = {}

local function tbl_clone(t)
    assert(type(t) == 'table')
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = v
    end
    return copy
end

local function tbl_apply(t, fn)
    assert(type(t) == 'table')
    assert(type(fn) == 'function')

    local r = {}
    for k, v in pairs(t) do
        r[k] = fn(v)
    end
    return r
end

local function tbl_filter(t, fn)
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

local function tbl_any(t, fn)
    assert(type(t) == 'table')
    assert(type(fn) == 'function')

    for k, v in pairs(t) do
        if fn(k, v) then
            return true
        end
    end

    return false
end

local function tbl_all(t, fn)
    assert(type(t) == 'table')
    assert(type(fn) == 'function')

    for k, v in pairs(t) do
        if not fn(k, v) then
            return false
        end
    end
    return true
end

local function tbl_reduce(t, fn, first)
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

local function tbl_contains_value(t, value)
    assert(type(t) == 'table')

    for _, v in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

local function tbl_contains_key(t, key)
    assert(type(t) == 'table')

    for k, _ in pairs(t) do
        if k == key then
            return true
        end
    end
    return false
end

local function tbl_count(t, fn)
    assert(type(t) == 'table')
    local _fn = fn
    if not _fn then
        _fn = function() return true end
    end
    assert(type(_fn) == 'function')

    local count = 0
    for k, v in pairs(t) do
        if _fn(k, v) then
            count = count + 1
        end
    end
    return count
end

local function tbl_equal(t1, t2, data_only, deep_compare)
    assert(type(t1) == 'table')
    assert(type(t2) == 'table')
    if tbl_count(t1) ~= tbl_count(t2) then
        return false
    end
    local t1_mt = getmetatable(t1)
    local t2_mt = getmetatable(t2)
    if t1_mt ~= t2_mt then
        return false
    end
    if t1_mt then
        for k, v in pairs(t1_mt) do
            print(k, v)
        end
    end
    for k, v in pairs(t1) do
        print(k, v)
        if (t2[k] == nil or t2[k] ~= v) then
            return false
        end
    end
    return true
end

tbl.filter = tbl_filter
tbl.all = tbl_all
tbl.any = tbl_any
tbl.apply = tbl_apply
tbl.clone = tbl_clone
tbl.reduce = tbl_reduce
tbl.count = tbl_count
tbl.contains_key = tbl_contains_key
tbl.contains_value = tbl_contains_value
tbl.equal = tbl_equal

return tbl
