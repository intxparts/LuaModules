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
    if tbl_count(t1) ~= tbl_count(t2) then
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

local _tbl = {}
_tbl.__index = _tbl

function _tbl.new(t)
    local t_type = type(t)
    assert(t_type == 'table' or t_type == 'nil')
    local wrp = t or {}
    setmetatable(wrp, _tbl)
    return wrp
end

function _tbl:filter(fn)
    return tbl_filter(self, fn)
end

function _tbl:all(fn)
    return tbl_all(t, fn)
end

function _tbl:any(fn)
    return tbl_any(self, fn)
end

function _tbl:apply(fn)
    return tbl_apply(self, fn)
end

function _tbl:clone()
    return tbl_clone(self)
end

function _tbl:reduce(fn, first)
    return tbl_reduce(self, fn, first)
end

function _tbl:count(fn)
    return tbl_count(self, fn)
end

function _tbl:contains_value(v)
    return tbl_contains_value(self, v)
end

function _tbl:contains_key(k)
    return tbl_contains_key(self, k)
end

function _tbl:deep_equal(t)
    return tbl_deep_equal(self, t)
end

local function tbl_wrap(t)
    return _tbl.new(t)
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
tbl.deep_equal = tbl_deep_equal
tbl.wrap = tbl_wrap

return tbl
