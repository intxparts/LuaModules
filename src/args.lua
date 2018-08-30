local tbl = require('tbl')
local str = require('str')

local args = {}
args.__index = args
args._arguments = {}
args._i = 1

function args:add_argument(arg_name, type_info, flags, nargs, required, help, default)
    assert(type(arg_name) == 'string')
    assert(type(type_info) == 'string')
    assert(type(nargs) == 'string' or type(nargs) == 'number')
    assert(flags ~= nil and type(flags) == 'table', "flags must be a valid table")
    local argument = {
        arg_name = arg_name,
        type_info = type_info,
        flags = flags,
        nargs = nargs,
        required = required and true or false,
        help = help, -- or generateHelp(arg_name),
        default = default
    }
    assert(self._arguments[self._i] == nil)
    self._arguments[self._i] = argument
    self._i = self._i + 1
end

function args:parse(a)
    assert(type(a) == 'table')
    local inputs = a or {}
    local function argument_type_mismatch_error(input, argument)
      error(
            string.format(
                'expected value: %d to be of type %q for argument %q',
                input, 
                argument.type_info, 
                argument.arg_name
            )
        )
    end
    local arguments = {}
    for i, argument in ipairs(self._arguments) do
        local arg_name_count = tbl.count(inputs, function(_, v) return tbl.any(argument.flags, function(_, flag) return flag == v end) end)
        assert(arg_name_count < 2, string.format('multiple counts of the same argument not supported: %q', argument.arg_name))
        
        if argument.required then
            assert(arg_name_count > 0, string.format('missing required argument %q', argument.arg_name))
        end

        if arg_name_count > 0 then
            local min_required_nargs = 0
            local max_nargs = 256

            if type(argument.nargs) == 'string' then
                if argument.nargs == '+' then
                    min_required_nargs = 1
                elseif argument.nargs == '*' then
                    min_required_nargs = 0
                else
                    error(string.format('invalid nargs field: %q provided for %q', argument.nargs, argument.arg_name))
                end
            elseif type(argument.nargs) == 'number' then
                assert(
                    argument.nargs > -1, 
                    string.format('invalid nargs value provided for argument: %q. nargs must be a whole number', argument.arg_name)
                )
                min_required_nargs = argument.nargs
                max_nargs = argument.nargs
            end

            if max_nargs == 0 then
                arguments[argument.arg_name] = true
                goto continue_next_argument
            end

            for i, input in ipairs(inputs) do

                if tbl.any(argument.flags, function(_, flag) return flag == input end) then
                    local arg_values = {}
                    local arg_value_idx = 1
                    while arg_value_idx + i <= #inputs and self._arguments[ inputs[i + arg_value_idx] ] == nil do
                        local current_input = inputs[i + arg_value_idx]
      
                        if argument.type_info == 'number' then 
                            local number = tonumber(current_input)
                            if not number then argument_type_mismatch_error(current_input, argument) end
                            arg_values[arg_value_idx] = number

                        elseif argument.type_info == 'integer' then
                            local integer = str.to_int(current_input)
                            if not integer then argument_type_mismatch_error(current_input, argument) end
                            arg_values[arg_value_idx] = integer

                        elseif argument.type_info == 'string' then
                            arg_values[arg_value_idx] = current_input

                        elseif argument.type_info == 'boolean' then
                            local bool = str.to_bool(current_input)
                            if not bool then argument_type_mismatch_error(current_input, argument) end
                            arg_values[arg_value_idx] = bool

                        else
                            arg_values[arg_value_idx] = nil
                        end
                        
                        arg_value_idx = arg_value_idx + 1
                    end -- while
                    
                    local arg_value_count = arg_value_idx
                    assert(min_required_nargs <= arg_value_count and arg_value_count <= max_nargs)
                    if arg_value_count > 0 then
                        arguments[argument.arg_name] = arg_values
                    else
                        if type(argument.default) ~= argument.type_info then
                            error(
                                string.format(
                                    'default argument %q type does not match the specified type: %q', 
                                    tostring(argument.default), 
                                    argument.type_info
                                )
                            )
                        end
                        arguments[argument.arg_name] = { argument.default }
                    end -- else
                    break
                end -- if tbl.any flags
            end -- for loop inputs
        end --if arg_name_count > 0
        ::continue_next_argument::

    end -- for loop argument
    return arguments
end

function args:print_help()
    local str_format = "%-15s | %-3s | %-25s | %-60s"
    print(string.format(str_format, "Argument", "Req", "Flags", "Description"))
    print(str.rep('-', 100))
    for i, v in ipairs(self._arguments) do
        local required_str = ' '
        if v.required then
            required_str = '.'
        end
        local flag_str = table.concat(v.flags, ",  ")
        print(string.format(str_format, v.arg_name, required_str, flag_str, v.help))
    end
end

return args
