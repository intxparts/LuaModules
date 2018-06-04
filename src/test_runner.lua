local path = require('path')
local test_lab = require('test_lab')
local args = require('args')

local function run_files(files)
    for _, f in pairs(files) do
        if not string.match(f, '.lua') then
            goto continue_files
        end
        
        if not path.exists(f) then
            print(string.format('provided file path %q does not exist'), f)
            return
        end
        -- might need to wrap this in pcall
        dofile(f)
        ::continue_files::
    end
end

args:add_argument('help', 'boolean', {'-h', '--help', '/?'}, 0, false, 'help_info_here')
args:add_argument('files', 'string', {'-f', '--files'}, '+', false, 'help_info_here')
args:add_argument('directories', 'string', {'-d', '--directories'}, '+', false, 'help_info_here')
args:add_argument('tags', 'string', {'-t', '--tags'}, '+', false, 'help_info_here')
-- verbosity level?

local result, data = pcall(args.parse, args, arg)
if not result then
    print(data)
    return
end

if data['help'] then
    args:print_help()
    return
end

if data['files'] then
    run_files(data['files'])
end

if data['directories'] then
    for _, d in pairs(data['directories']) do
        if not path.exists(d) then
            print(string.format('provided directory path %q does not exist', d))
            return
        end
        local files = path.list_files(d, true)
        run_files(files)
    end
end

test_lab:run()
