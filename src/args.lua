local fnl = require('fnl')
local str = require('str')

local args = {}
args.__index = args
args._arguments = {}

function args:add_argument(arg_name, type_info, flags, nargs, required, help, default)
    assert(type(arg_name) == 'string')
    assert(type(type_info) == 'string')
    assert(type(nargs) == 'string' or type(nargs) == 'number')
    local argument = {
        arg_name = arg_name,
        type_info = type_info,
        flags = flags,
        nargs = nargs,
        required = required and true or false,
        help = help, -- or generateHelp(arg_name),
        default = default
    }
    assert(self._arguments[arg_name] == nil)
    self._arguments[arg_name] = argument
end

function args:parse(a)
    return self:_verify(a)
end

function args:print_help()
    print('tbd - args:print_help()')
end

function args:_verify(a)
    assert(type(a) == 'table')
    local inputs = a or {}
    local function invalid_argument_error(input, argument)
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
    for arg_name, argument in pairs(self._arguments) do
        local arg_name_count = fnl.count(inputs, function(_, v) return fnl.any(argument.flags, function(_, flag) return flag == v end) end)
        assert(arg_name_count < 2, string.format('multiple counts of the same argument not supported: %q', arg_name))
        
        if argument.required then
            assert(arg_name_count > 0, string.format('missing required argument %q', arg_name))
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


                if fnl.any(argument.flags, function(_, flag) return flag == input end) then
                    local arg_values = {}
                    local arg_value_idx = 1
                    while arg_value_idx + i <= #inputs and self._arguments[ inputs[i + arg_value_idx] ] == nil do
                        local current_input = inputs[i + arg_value_idx]
      
                        if argument.type_info == 'number' then 
                            
                            local number = tonumber(current_input)
                            if not number then invalid_argument_error(current_input, argument) end
                            arg_values[arg_value_idx] = number

                        elseif argument.type_info == 'integer' then
                            
                            local integer = str.to_integer(current_input)
                            if not integer then invalid_argument_error(current_input, argument) end
                            arg_values[arg_value_idx] = integer

                        elseif argument.type_info == 'string' then
                            
                            arg_values[arg_value_idx] = current_input

                        elseif argument.type_info == 'boolean' then
                            
                            local bool = str.to_bool(current_input)
                            if not bool then invalid_argument_error(current_input, argument) end
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
                end -- if fnl.any flags
            end -- for loop inputs
        end --if arg_name_count > 0
        ::continue_next_argument::

    end -- for loop argument
    return arguments
end

return args
