local zeroWidthChars = {"\u{200B}", "\u{200C}", "\u{200D}", "\u{FEFF}"}
local function insertZeroWidth(text, probability)
    probability = probability or 0.3
    local result = ""
    for i = 1, #text do
        result = result .. text:sub(i, i)
        if math.random() < probability then
            result = result .. zeroWidthChars[math.random(#zeroWidthChars)]
        end
    end
    return result
end
return { insertZeroWidth = insertZeroWidth }