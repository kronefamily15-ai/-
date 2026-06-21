local HttpService = game:GetService("HttpService")
local CONFIG_URL = ""
local EXTRA_URL = ""

local function fetchJSON(url)
    local success, data = pcall(function() return HttpService:GetAsync(url) end)
    if success and data then return HttpService:JSONDecode(data) end
    return nil
end

local function getGlyphMap()
    local config = fetchJSON(CONFIG_URL)
    if config and config.map then return config.map end
    local extra = fetchJSON(EXTRA_URL)
    if extra and extra.map then return extra.map end
    return {a={"а"}, e={"е"}, o={"о"}, p={"р"}, c={"с"}, x={"х"}, y={"у"}}
end

return {
    getGlyphMap = getGlyphMap,
    updateEvery = function(seconds, callback)
        while true do
            task.wait(seconds)
            local newMap = getGlyphMap()
            if newMap then callback(newMap) end
        end
    end
}