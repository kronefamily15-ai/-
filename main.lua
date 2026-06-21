print("antiprint")

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local player = Players.LocalPlayer

local BASE_URL = ""

local function loadModule(name)
    local url = BASE_URL .. name
    local success, code = pcall(function() return HttpService:GetAsync(url) end)
    if success and code then
        return loadstring(code)()
    end
    return nil
end

local zeroWidth = loadModule("zero_width.lua")
local unicodeObf = loadModule("unicode_obf.lua")
local antiSpam = loadModule("anti_spam.lua")

local CONFIG_URL = BASE_URL .. "config.json"
local EXTRA_URL = BASE_URL .. "extra_symbols.json"

local function fetchConfig(url)
    local success, data = pcall(function() return HttpService:GetAsync(url) end)
    if success and data then
        return HttpService:JSONDecode(data)
    end
    return nil
end

local function getGlyphMap()
    local config = fetchConfig(CONFIG_URL)
    if config and config.map then return config.map end
    local extra = fetchConfig(EXTRA_URL)
    if extra and extra.map then return extra.map end
    return {a={"а"}, e={"е"}, o={"о"}, p={"р"}, c={"с"}, x={"х"}, y={"у"}}
end

local glyphMap = getGlyphMap()

local function obfuscateText(text)
    local result = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        local lower = char:lower()
        local replacementTable = glyphMap[lower]
        if replacementTable then
            local replacement = type(replacementTable) == "table" and replacementTable[math.random(#replacementTable)] or replacementTable
            if char:match("%u") then replacement = replacement:upper() end
            result = result .. replacement
        else
            result = result .. char
        end
    end
    if zeroWidth then result = zeroWidth.insertZeroWidth(result, 0.2) end
    if unicodeObf then result = unicodeObf.addDiacritics(result, 0.15) end
    return result
end

local function hookNovaChat()
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return end
    local novachat = playerGui:FindFirstChild("NovaChat")
    if not novachat then
        local originalSend = TextChatService.TextChannels.RBXGeneral.SendAsync
        if originalSend then
            TextChatService.TextChannels.RBXGeneral.SendAsync = function(self, text, ...)
                local obf = obfuscateText(text)
                if antiSpam then
                    return antiSpam.sendWithAntiSpam(function(t) return originalSend(self, t, ...) end, obf, 0.3, 0.8)
                end
                return originalSend(self, obf, ...)
            end
        end
        return
    end

    local function findSendModule(parent)
        for _, child in ipairs(parent:GetDescendants()) do
            if child:IsA("ModuleScript") then
                local ok, mod = pcall(require, child)
                if ok and type(mod) == "table" then
                    if type(mod.SendAsync) == "function" then return child, "SendAsync" end
                    if type(mod.SendMessage) == "function" then return child, "SendMessage" end
                end
            end
        end
        return nil, nil
    end

    local module, methodName = findSendModule(novachat)
    if module and methodName then
        local original = require(module)[methodName]
        require(module)[methodName] = function(self, text, ...)
            local obf = obfuscateText(text)
            if antiSpam then
                return antiSpam.sendWithAntiSpam(function(t) return original(self, t, ...) end, obf, 0.3, 0.8)
            end
            return original(self, obf, ...)
        end
    else
        local originalSend = TextChatService.TextChannels.RBXGeneral.SendAsync
        if originalSend then
            TextChatService.TextChannels.RBXGeneral.SendAsync = function(self, text, ...)
                local obf = obfuscateText(text)
                if antiSpam then
                    return antiSpam.sendWithAntiSpam(function(t) return originalSend(self, t, ...) end, obf, 0.3, 0.8)
                end
                return originalSend(self, obf, ...)
            end
        end
    end
end

hookNovaChat()