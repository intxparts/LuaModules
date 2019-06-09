local tbl = require('tbl')
local str = require('str')

local args = {}
args.__index = args
args._cmds = {}
args._i = 1

local valid_arg_types = {'string', 'number', 'boolean'}

-- need to fix handling of multiple '+' arguments

function args:add_command(cmd_name, type_info, flags, nargs, required, help, default)
    assert(type(cmd_name) == 'string')
    assert(type(type_info) == 'string')
    assert(tbl.contains_value(valid_arg_types, type_info), 'invalid argument type')
    assert(type(nargs) == 'string' or type(nargs) == 'number')
    assert(flags ~= nil and type(flags) == 'table', 'flags must be a valid table')
    assert(type(required) == 'boolean')
    assert(type(help) == 'string')
    local cmd = {
        name = cmd_name,
        type_info = type_info,
        flags = flags,
        nargs = nargs,
        required = required,
        help = help,
        default = default
    }
    assert(self._cmds[self._i] == nil)
    self._cmds[self._i] = cmd
    self._i = self._i + 1
end

function args:parse(a)
    assert(type(a) == 'table')
    local inputs = a
    local function cmd_type_mismatch_error(input, cmd)
      error(
            string.format(
                'expected value: %d to be of type %q for command %q',
                input,
                cmd.type_info,
                cmd.name
            )
        )
    end

    local function collect_cmd_args(cmd_flags, i, inputs, matching_cmd, cmds)
        local min_required_nargs = 0
        local max_nargs = 256
        -- check matching_cmd.nargs
        if type(matching_cmd.nargs) == 'string' then
            if matching_cmd.nargs == '+' then
                min_required_nargs = 1
            elseif matching_cmd.nargs == '*' then
                min_required_nargs = 0
            else
                error(string.format('invalid nargs field: %q provided for %q', matching_cmd.nargs, matching_cmd.name))
            end
        elseif type(matching_cmd.nargs) == 'number' then
            assert(
                matching_cmd.nargs > -1,
                string.format('invalid nargs value provided for command: %q. nargs must be a whole number', matching_cmd.name)
            )
            min_required_nargs = matching_cmd.nargs
            max_nargs = matching_cmd.nargs
        end
        local cmd_args = {}
        local num_args = 1
        -- process up until the next command is identified
        while num_args < max_nargs and i < tbl.count(inputs) do
            -- return the previous idx so that the next cmd_flag can be properly processed
            if cmd_flags[inputs[i]] then
                break
            end

            if matching_cmd.type_info == 'number' then
                local number = tonumber(inputs[i])
                if not number then cmd_type_mismatch_error(inputs[i], matching_cmd) end
                cmd_args[num_args] = number

            elseif matching_cmd.type_info == 'integer' then
                local integer = str.to_int(inputs[i])
                if not integer then cmd_type_mismatch_error(inputs[i], matching_cmd) end
                cmd_args[num_args] = integer

            elseif matching_cmd.type_info == 'string' then
                cmd_args[num_args] = inputs[i]

            elseif matching_cmd.type_info == 'boolean' then
                local bool = str.to_bool(inputs[i])
                if not bool then cmd_type_mismatch_error(inputs[i], matching_cmd) end
                cmd_args[num_args] = bool

            else
                cmd_args[num_args] = nil
            end
            num_args = num_args + 1
            i = i + 1
        end
        if max_nargs == 0 then
            cmds[matching_cmd.name] = true
            return i
        end

        assert(min_required_nargs <= num_args and num_args <= max_nargs, string.format('invalid number of arguments provided for command: %q', matching_cmd.name))
        if num_args > 0 then
            cmds[matching_cmd.name] = cmd_args
        else
            if type(matching_cmd.default) ~= matching_cmd.type_info then
                error(
                    string.format(
                        'default argument %q type does not match the specified type: %q',
                        tostring(matching_cmd.default),
                        matching_cmd.type_info
                    )
                )
            end
            cmds[matching_cmd.name] = { matching_cmd.default }
        end

        return i - 1
    end

    -- build a lookup table
    -- flag -> argument_idx
    local cmd_flags = {}
    for i, c in ipairs(self._cmds) do
        for _, f in pairs(c.flags) do
            cmd_flags[f] = i
        end
    end

    local cmds = {}
    local i = 1
    local num_inputs = tbl.count(inputs) + 1
    while i < num_inputs do
        local matching_cmd_idx = cmd_flags[inputs[i]]
        if matching_cmd_idx then
            i = collect_cmd_args(cmd_flags, i+1, inputs, self._cmds[matching_cmd_idx], cmds)
        end
        i = i + 1
    end
    for _, cmd in pairs(self._cmds) do
        if cmd.required then
            assert(cmds[cmd.name] ~= nil, string.format('missing required command %q', cmd.name))
        end
    end

    return cmds
end

return args
