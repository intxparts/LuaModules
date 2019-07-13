local timer = {}
timer.__index = timer

function timer.ctime(invokable)
    local t_start = os.clock()
    invokable()
    local t_end = os.clock()
    return t_end - t_start
end

function timer.time(invokable)
    local t_start = os.time()
    invokable()
    local t_end = os.time()
    return os.difftime(t_end, t_start)
end

return timer
