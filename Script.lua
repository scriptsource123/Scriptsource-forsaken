--[[ 
    ScriptSource HUB – Chance / Guest / Main Tabs
    Main: Infinite Stamina, Killer ESP, Infinite Yield
    Guest: Auto Block, Auto Punch, Fling, etc.
]]--

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local PlayerGui = lp:WaitForChild("PlayerGui")

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "Scriptsource HUB",
    LoadingTitle = "Loading scriptsource HUB",
    ConfigurationSaving = {Enabled = true, FolderName = "scriptsrouceHUB", FileName = "Settings"},
    Discord = {Enabled = false},
    KeySystem = false
})

-- Create Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local GuestTab = Window:CreateTab("Guest", 4483362458)

-- ================= MAIN TAB =================
-- Infinite Stamina Variables
local infiniteStamina = false
local customStamina = 100

-- Function to set stamina
local function setCustomStamina(amount)
    local success, StaminaModule = pcall(function()
        return require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
    end)
    if not success or not StaminaModule then return end

    StaminaModule.StaminaLossDisabled = true
    task.spawn(function()
        while infiniteStamina and StaminaModule do
            task.wait(0.1)
            StaminaModule.Stamina = amount
            StaminaModule.StaminaChanged:Fire()
        end
    end)
end

-- Function to disable stamina override
local function disableCustomStamina()
    local success, StaminaModule = pcall(function()
        return require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
    end)
    if success and StaminaModule then
        StaminaModule.StaminaLossDisabled = false
    end
end

-- Infinite Stamina Toggle
MainTab:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Callback = function(value)
        infiniteStamina = value
        if value then
            setCustomStamina(customStamina)
        else
            disableCustomStamina()
        end
    end
})

-- Stamina Input Box
MainTab:CreateInput({
    Name = "Set Stamina",
    PlaceholderText = "100",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local val = tonumber(text)
        if val then
            customStamina = val
            if infiniteStamina then
                setCustomStamina(customStamina)
            end
        end
    end
})

-- Killer ESP
local espEnabled = false
local KillersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")

local function addESP(obj)
    if not obj:IsA("Model") then return end
    if not obj:FindFirstChild("HumanoidRootPart") then return end
    if obj:FindFirstChild("ESP_Highlight") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = obj
    highlight.Parent = obj

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.Adornee = obj:FindFirstChild("HumanoidRootPart")
    billboard.Parent = obj

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "ESP_Text"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Text = obj.Name
    textLabel.Parent = billboard
end

local function clearESP(obj)
    if obj:FindFirstChild("ESP_Highlight") then obj.ESP_Highlight:Destroy() end
    if obj:FindFirstChild("ESP_Billboard") then obj.ESP_Billboard:Destroy() end
end

local function refreshESP()
    if not espEnabled then
        for _, killer in pairs(KillersFolder:GetChildren()) do
            clearESP(killer)
        end
        return
    end
    for _, killer in pairs(KillersFolder:GetChildren()) do
        addESP(killer)
    end
end

KillersFolder.ChildAdded:Connect(function(child)
    if espEnabled then task.wait(0.1); addESP(child) end
end)
KillersFolder.ChildRemoved:Connect(function(child) clearESP(child) end)

RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, killer in pairs(KillersFolder:GetChildren()) do
        local billboard = killer:FindFirstChild("ESP_Billboard")
        if billboard and billboard:FindFirstChild("ESP_Text") and killer:FindFirstChild("HumanoidRootPart") then
            local dist = (killer.HumanoidRootPart.Position - hrp.Position).Magnitude
            billboard.ESP_Text.Text = string.format("%s\n[%d]", killer.Name, dist)
        end
    end
end)

-- ESP Toggle
MainTab:CreateToggle({
    Name = "Killer ESP",
    CurrentValue = false,
    Callback = function(value)
        espEnabled = value
        refreshESP()
    end
})

-- Infinite Yield Button
MainTab:CreateButton({
    Name = "Run Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

-- ================= GUEST TAB =================
-- All your old block, punch, fling, and fake block code goes here
-- Just copy the buttons and toggles from your previous Guest tab script
-- Example:
GuestTab:CreateToggle({Name="Auto Block", CurrentValue=false, Callback=function(val) autoBlockOn=val end})
GuestTab:CreateToggle({Name="Auto Punch", CurrentValue=false, Callback=function(val) autoPunchOn=val end})
GuestTab:CreateToggle({Name="Fling Punch", CurrentValue=false, Callback=function(val) flingPunchOn=val end})
-- Add all other Guest functionality here...

