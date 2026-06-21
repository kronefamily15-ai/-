local diacritics = {"\u{0300}","\u{0301}","\u{0302}","\u{0303}","\u{0304}","\u{0306}","\u{0307}","\u{0308}","\u{030A}","\u{030B}","\u{030C}","\u{030F}","\u{0310}","\u{0311}","\u{0312}"}
local function addDiacritics(text, probability)
    probability = probability or 0.2
    local result = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        if char:match("%w") and math.random() < probability then
            result = result .. char .. diacritics[math.random(#diacritics)]
        else
            result = result .. char
        end
    end
    return result
end
return { addDiacritics = addDiacritics }