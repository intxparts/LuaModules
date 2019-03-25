local benchmark = {}
benchmark.__index = benchmark

function benchmark.etime(fn)
    assert(type(fn) == 'function')
    local t_start = os.clock()
    fn()
    local t_end = os.clock()
    return t_end - t_start
end

function benchmark.time(fn)
    assert(type(fn) == 'function')
    local t_start = os.time()
    fn()
    local t_end = os.time()
    return os.difftime(t_end, t_start)
end

return benchmark
