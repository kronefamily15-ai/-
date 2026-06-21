local Players = game:GetService("Players")
local player = Players.LocalPlayer
local function hideAllGuis()
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        for _, child in ipairs(playerGui:GetChildren()) do
            if child:IsA("ScreenGui") then child.Enabled = false end
        end
    end
end
local function showAllGuis()
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        for _, child in ipairs(playerGui:GetChildren()) do
            if child:IsA("ScreenGui") then child.Enabled = true end
        end
    end
end
return { hideAllGuis = hideAllGuis, showAllGuis = showAllGuis }