function getvalue(lit)
    if lit <= 3 then
        return lit
    end
    if lit == 4 then
        return registers.A
    end
    if lit == 5 then
        return registers.B
    end
    if lit == 6 then
        return registers.C
    end
    return -1
end

local file = io.open("input.txt", "r")
registers = {}
program = {}

for line in file:lines() do
    local regName, regValue = line:match("Register (%a+): (%d+)")
    if regName and regValue then
        registers[regName] = tonumber(regValue)
    end

    local progValues = line:match("Program:%s*([%d,]+)")
    if progValues then
        for value in progValues:gmatch("%d+") do
            table.insert(program, tonumber(value))
        end
    end
end
file:close()

local eip = 1
local output = {}

while eip <= #program do
    local opcode = program[eip]
    local operand = program[eip + 1] or 0

    if opcode == 0 then
        local divisor = 2 ^ getvalue(operand)
        registers.A = math.floor(registers.A / divisor)
        eip = eip + 2

    elseif opcode == 1 then
        registers.B = registers.B ~ operand
        eip = eip + 2

    elseif opcode == 2 then
        registers.B = getvalue(operand) % 8
        eip = eip + 2

    elseif opcode == 3 then
        if registers.A == 0 then
            eip = eip + 2
        else
            eip = operand + 1
        end

    elseif opcode == 4 then
        registers.B = registers.B ~ registers.C
        eip = eip + 2

    elseif opcode == 5 then
        local result = getvalue(operand) % 8
        table.insert(output, result)
        eip = eip + 2

    elseif opcode == 6 then
        local divisor = 2 ^ getvalue(operand)
        registers.B = math.floor(registers.A / divisor)
        eip = eip + 2

    else
        local divisor = 2 ^ getvalue(operand)
        registers.C = math.floor(registers.A / divisor)
        eip = eip + 2
    end
end

print(table.concat(output, ","))
