local fnl = require('fnl')
local test_lab = {}

test_lab._current = {
    groups = {},
    tests = {} -- support for tests outside of groups
}

-- [] need to clean up what is print out to console & make it more readable
-- [] currently adding print statements to unit tests that are failing do not work - only on ones that succeed - need to fix this


function test_lab:group(description, fn, tags)
    assert(type(fn) == 'function')
    local child = {
        description = description,
        fn = fn,
        parent = self._current,
        before_eaches = {},
        befores = {},
        tests = {},
        after_eaches = {},
        afters = {},
        tags = tags or {}
    }

    table.insert(self._current.groups, child)
    self._current = child
    local result, message = pcall(fn)
    self._current = child.parent

end

function test_lab:test(description, fn)
    assert(type(fn) == 'function')
    local test = {
        description = description,
        fn = fn
    }
    table.insert(self._current.tests, test)
end

function test_lab:before(fn)
    assert(type(fn) == 'function')
    table.insert(self._current.befores, fn)
end

function test_lab:after(fn)
    assert(type(fn) == 'function')
    table.insert(self._current.afters, fn)
end

function test_lab:before_each(fn)
    assert(type(fn) == 'function')
    table.insert(self._current.before_eaches, fn)
end

function test_lab:after_each(fn)
    assert(type(fn) == 'function')
    table.insert(self._current.after_eaches, fn)
end

function test_lab:run(tags)
    local t_start = os.time()
    local successes = 0
    local failures = 0
    print('running unit tests')
    for _i, t in pairs(self._current.tests) do
        print(t.description)
        local result, message = pcall(t.fn)
        print('test_result: ', result)

        if result then
            successes = successes + 1
        else
            failures = failures + 1
        end
    end

    local groups = self._current.groups
    if tags then
        local function tag_in_input_tags(_, tag) return fnl.contains_key(tags, tag) end
        local function group_tags_contain_all_input_tags(_, group) return fnl.all(group.tags, tag_in_input_tags) end
        groups = fnl.filter(self._current.groups, group_tags_contain_all_input_tags)
    end
    for _i, v in pairs(groups) do
        print(v.description)
        for _j, b in pairs(v.befores) do
            local result, message = pcall(b)
        end
        
        for _j, t in pairs(v.tests) do

            for _k, be in pairs(v.before_eaches) do
                local result, message = pcall(be)
            end

            local result, message = pcall(t.fn)
            if result then
                print('.', t.description)
            else
                print('x', t.description, message)
            end
    
            if result then
                successes = successes + 1
            else
                failures = failures + 1
            end

            for _k, ae in pairs(v.after_eaches) do
                local result, message = pcall(ae)
            end
        
        end

        for _j, a in pairs(v.afters) do
            local result, message = pcall(a)
        end
    end
    local t_end = os.time()
    local total_tests = successes + failures
    print('\n')
    print('~- Test Summary -~')
    print(total_tests, " tests run total")
    print(successes, " tests passed")
    print(failures, " tests failed")
    print(os.difftime(t_end, t_start), "seconds to execute")
end

return test_lab
