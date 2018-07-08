package.path = package.path .. '; ..\\?.lua; ..\\src\\?.lua'

local test_lab = require('test_lab')
local str = require('str')

test_lab:group('str.rep ->', function()
    
    test_lab:test('replicate single char string', function()
        assert('-----' == str.rep('-', 5))
    end)

    test_lab:test('replicate string with no separator', function()
        assert('hellohellohello' == str.rep('hello', 3))
    end)

    test_lab:test('replicate string with single char separator', function()
        assert('hello,hello' == str.rep('hello', 2, ','))
    end)

    test_lab:test('replicate string with multi-char separator', function()
        assert('hello | hello' == str.rep('hello', 2, ' | '))
    end)

    local data_set = { -3, -2, -1, 0, 1 }
    for _, v in ipairs(data_set) do
        test_lab:test(string.format('replicate string %d times', v), function()
            assert('hello' == str.rep('hello', v))
        end)
    end

    test_lab:test('str.rep(s, n, sep), s must be a string', function()
        local result, message = pcall(function() local my_str = str.rep(12, 2) end)
        assert(result == false)
    end)

    test_lab:test('str.rep(s, n, sep), n must be a number', function()
        local result, message = pcall(function() local my_str = str.rep('hello', '10') end)
        assert(result == false)
    end)

end)

test_lab:group('str.join ->', function()

    test_lab:test('nil table', function()
        local result, message = pcall(function() local s = str.join(nil) end)
        assert(result == false)
    end)

    test_lab:test('join single string', function()
        assert('hello, world!' == str.join({'hello, world!'}))
    end)

    test_lab:test('join single string with single-char separator', function()
        assert('hello, world!' == str.join({'hello, world!'}, ','))
    end)

    test_lab:test('join single string with multi-char separator', function()
        assert('hello, world!' == str.join({'hello, world!'}, ', '))
    end)

    test_lab:test('join multiple strings', function()
        assert('hello, world!' == str.join({'hello', ', ', 'world!'}))
    end)

    test_lab:test('join multiple strings with single-char separator', function()
        assert('hello, world!' == str.join({'hello', ' world!'}, ','))
    end)

    test_lab:test('join multiple strings with multi-char separator', function()
        assert('hello, world!' == str.join({'hello', 'world!'}, ', '))
    end)

    test_lab:test('join with nil in table', function()
        assert('hello' == str.join({[1]='hello',[2]=nil,[3]='world!'}))
    end)

    test_lab:test('join different types', function()
        local point = { __tostring = function() return '(0, 0)' end }
        local origin = setmetatable({}, point)

        assert('2D Cartesian Origin is (0, 0) is a true statement' == str.join({2, 'D Cartesian Origin is ', origin, ' is a ', true, ' statement'}))
    end)

    test_lab:test('join strings with numerical separator', function()
        assert('col10.0col20.0col3' == str.join({'col1', 'col2', 'col3'}, 0.0))
    end)

    test_lab:test('join strings with boolean separator', function()
        assert('col1truecol2truecol3' == str.join({'col1', 'col2', 'col3'}, true))
    end)

    test_lab:test('join strings with custom format separator', function()
        local format = { __tostring = function() return ' | ' end }
        local sep_format = setmetatable({}, format)

        assert('col1 | col2 | col3' == str.join({'col1', 'col2', 'col3'}, sep_format))
    end)

end)
