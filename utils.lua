local function randomChoice(tbl) return tbl[math.random(#tbl)] end
local function shuffleString(str)
    local arr = {}
    for i = 1, #str do arr[i] = str:sub(i, i) end
    for i = #arr, 2, -1 do
        local j = math.random(i)
        arr[i], arr[j] = arr[j], arr[i]
    end
    return table.concat(arr)
end
return { randomChoice = randomChoice, shuffleString = shuffleString }