-- opensource HUB - Main + Guest Tabs
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "scriptSource HUB",
    LoadingTitle = "scriptsource HUB",
    LoadingSubtitle = "by Scriptsource",
    ConfigurationSaving = {Enabled = true, FolderName = "scriptsourceHUB", FileName = "Settings"},
    Discord = {Enabled = false},
    KeySystem = false
})

-- ========== Tabs ==========
local MainTab = Window:CreateTab("Main", 4483362458)
local GuestTab = Window:CreateTab("Guest", 4483362458)

-- Remove Chance tab
-- local ChanceTab = Window:CreateTab("Chance", 4483362458)

-- ===== Services & Variables =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local PlayerGui = lp:WaitForChild("PlayerGui")
local KillersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")

-- State variables
local autoBlockOn, autoBlockAudioOn, doubleblocktech = false, false, false
local looseFacing = true
local detectionRange = 18
local predictiveBlockOn = false
local edgeKillerDelay = 3
local autoPunchOn, flingPunchOn, aimPunch = false, false, false
local flingPower = 10000
local customBlockEnabled, customPunchEnabled = false, false
local customBlockAnimId, customPunchAnimId = "", ""
local infiniteStamina, espEnabled = false, false
local blockTPEnabled = false
local customChargeEnabled, customChargeAnimId = false, ""
local lastBlockTime, lastPunchTime = 0, 0

-- ===== Main Tab Features =====

-- Infinite Stamina
MainTab:CreateToggle({Name = "Infinite Stamina", CurrentValue = false, Callback = function(val)
    infiniteStamina = val
    if infiniteStamina then
        local success, StaminaModule = pcall(function() return require(ReplicatedStorage.Systems.Character.Game.Sprinting) end)
        if success and StaminaModule then
            StaminaModule.StaminaLossDisabled = true
        end
    else
        local success, StaminaModule = pcall(function() return require(ReplicatedStorage.Systems.Character.Game.Sprinting) end)
        if success and StaminaModule then
            StaminaModule.StaminaLossDisabled = false
        end
    end
end})

-- Killer ESP
MainTab:CreateToggle({Name = "Killer ESP", CurrentValue = false, Callback = function(val) espEnabled = val end})

-- Infinite Yield
MainTab:CreateButton({Name = "Run Infinite Yield", Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end})
MainTab:CreateParagraph({Title = "Tip", Content = 'Run Infinite Yield and type "antifling" so punch fling works better.'})

-- ===== Guest Tab Features =====

-- Auto Block
GuestTab:CreateToggle({Name = "Auto Block (Animation)", CurrentValue = false, Callback = function(val) autoBlockOn = val end})
GuestTab:CreateToggle({Name = "Auto Block (Audio)", CurrentValue = false, Callback = function(val) autoBlockAudioOn = val end})
GuestTab:CreateToggle({Name = "Double Punch Tech", CurrentValue = false, Callback = function(val) doubleblocktech = val end})
GuestTab:CreateParagraph({Title = "Recommendation", Content = "Use audio auto block and use 20 range for it"})
GuestTab:CreateToggle({Name = "Enable Facing Check", CurrentValue = true, Callback = function(val) looseFacing = val end})
GuestTab:CreateDropdown({Name = "Facing Check", Options = {"Loose","Strict"}, CurrentOption = "Loose", Callback = function(option) looseFacing = option == "Loose" end})
GuestTab:CreateInput({Name = "Detection Range", PlaceholderText = "18", Callback = function(txt) detectionRange = tonumber(txt) or detectionRange end})
GuestTab:CreateToggle({Name = "Range Visual", CurrentValue = false, Callback = function(state) end})
GuestTab:CreateToggle({Name = "Block TP", CurrentValue = false, Callback = function(val) blockTPEnabled = val end})

-- Predictive Auto Block
GuestTab:CreateToggle({Name = "Predictive Auto Block", CurrentValue = false, Callback = function(val) predictiveBlockOn = val end})
GuestTab:CreateInput({Name = "Detection Range", PlaceholderText = "10", Callback = function(txt) detectionRange = tonumber(txt) or detectionRange end})
GuestTab:CreateSlider({Name = "Edge Killer", Range = {0,7}, Increment = 0.1, CurrentValue = 3, Callback = function(val) edgeKillerDelay = val end})
GuestTab:CreateParagraph({Title = "Edge Killer", Content = "How many secs until it blocks (resets when killer gets out of range)"})

-- Fake Block
GuestTab:CreateButton({Name = "Load Fake Block", Callback = function()
    pcall(function()
        local fakeGui = PlayerGui:FindFirstChild("FakeBlockGui")
        if not fakeGui then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/skibidi399/Auto-block-script/refs/heads/main/fakeblock"))()
        else
            fakeGui.Enabled = true
        end
    end)
end})

-- Auto Punch
GuestTab:CreateToggle({Name = "Auto Punch", CurrentValue = false, Callback = function(val) autoPunchOn = val end})
GuestTab:CreateToggle({Name = "Fling Punch", CurrentValue = false, Callback = function(val) flingPunchOn = val end})
GuestTab:CreateToggle({Name = "Punch Aimbot", CurrentValue = false, Callback = function(val) aimPunch = val end})
GuestTab:CreateSlider({Name = "Aim Prediction", Range = {0,10}, Increment = 0.1, CurrentValue = 4, Callback = function(val) predictionValue = val end})
GuestTab:CreateSlider({Name = "Fling Power", Range = {5000,50000000000000}, Increment = 1000000, CurrentValue = 10000, Callback = function(val) flingPower = val end})

-- Custom Animations (Optional)
GuestTab:CreateInput({Name = "Custom Block Animation", PlaceholderText = "AnimationId", Callback = function(txt) customBlockAnimId = txt end})
GuestTab:CreateToggle({Name = "Enable Custom Block Animation", CurrentValue = false, Callback = function(val) customBlockEnabled = val end})
GuestTab:CreateInput({Name = "Custom Punch Animation", PlaceholderText = "AnimationId", Callback = function(txt) customPunchAnimId = txt end})
GuestTab:CreateToggle({Name = "Enable Custom Punch Animation", CurrentValue = false, Callback = function(val) customPunchEnabled = val end})
GuestTab:CreateInput({Name = "Charge Animation ID", PlaceholderText = "AnimationId", Callback = function(txt) customChargeAnimId = txt end})
GuestTab:CreateToggle({Name = "Custom Charge Animation", CurrentValue = false, Callback = function(val) customChargeEnabled = val end})
