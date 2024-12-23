function run(regA)
    local output = {}
    while regA > 0 do
        local B = (regA % 8) ~ 7
        local C = math.floor(regA / (2 ^ B))
        regA = math.floor(regA / 8)
        B = B ~ 7 ~ C
        table.insert(output, B % 8)
    end
    return output
end

local power = 15
local seq = {2, 4, 1, 7, 7, 5, 0, 3, 1, 7, 4, 1, 5, 5, 3, 0}
local outputs = {8 ^ 15}

while power >= 0 do
    local new_outputs = {}
    for _, val in ipairs(outputs) do
        for i = 0, 7 do
            local A = val + (8 ^ power) * i
            local out = run(A)

            local seq_last_digit = seq[#seq]
            local out_last_digit = out[power + 1]

            if #out <= 16 and out_last_digit == seq_last_digit then
                table.insert(new_outputs, A)
            end
        end
    end

    table.remove(seq)

    outputs = new_outputs
    power = power - 1
end

table.sort(outputs)
print(string.format("%d", outputs[1]))