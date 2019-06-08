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
            table.insert(r, v)
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
        if type(t) ~= 'function' and v == value then
            return true
        end
    end
    return false
end

local function tbl_contains_fn(t, fn)
    assert(type(t) == 'table')

    for _, v in pairs(t) do
        if type(t) == 'function' and v == value then
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
    local fn_type = type(fn)
    assert(fn_type == 'function' or fn_type == 'nil')
    local _fn = fn
    if not _fn then
        _fn = function() return true end
    end

    local count = 0
    for k, v in pairs(t) do
        if _fn(k, v) then
            count = count + 1
        end
    end
    return count
end

local function tbl_deep_equal(t1, t2)
    assert(type(t1) == 'table')
    assert(type(t2) == 'table')
    local include_all_tbl_values = function() return true end
    if tbl_count(t1, include_all_tbl_values) ~= tbl_count(t2, include_all_tbl_values) then
        return false
    end
    for k, t1_k in pairs(t1) do
        t1_k_type = type(t1_k)
        if t1_k_type ~= type(t2[k]) then
            return false
        end

        if t1_k_type == 'table' then
            if not tbl_deep_equal(t1_k, t2[k]) then
                return false
            end
        -- elseif t1_k_type == 'function' or
        --     t1_k_type == 'userdata' or
        --     t1_k_type == 'thread' then
        --     goto next_property_continue
        else
            if t1_k ~= t2[k] then
                return false
            end
        end
        -- ::next_property_continue::
    end
    return true
end

local function tbl_iter(t, fn)
    assert(type(t) == 'table')
    for k, v in pairs(t) do
        fn(k, v)
    end
end

local function tbl_impl(t1, t2)
    assert(type(t1) == 'table')
    assert(type(t2) == 'table')
    for k, v in pairs(t2) do
        if type(v) == 'function' then
            assert(t1[k] == nil, string.format('key %q is not nil', k))
            t1[k] = v
        end
    end
    return t1
end

local function tbl_inst(t)
    return tbl_impl(t, tbl)
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
tbl.contains_fn = tbl_contains_fn
tbl.deep_equal = tbl_deep_equal
tbl.impl = tbl_impl
tbl.inst = tbl_inst
tbl.iter = tbl_iter

return tbl
