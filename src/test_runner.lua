local path = require('path')
local test_lab = require('test_lab')

local test_dir = arg[1]
local files = path.list_files(test_dir, true)

for _, f in pairs(files) do
    if string.match(f, '.lua') then
        dofile(f)
    end
end

test_lab:run()
