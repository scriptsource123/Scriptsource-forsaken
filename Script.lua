-- Auto Block & Main Hub Script (Full Features)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local PlayerGui = lp:WaitForChild("PlayerGui")
local Humanoid, Animator

-- Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "SourceHub Hub",
    LoadingTitle = "Loading SourceHub|Forsaken",
    LoadingSubtitle = "by scriptsource",
    ConfigurationSaving = {Enabled = true, FolderName = "scriptsourceHub", FileName = "Settings"},
    Discord = {Enabled = false},
    KeySystem = false
})

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local GuestTab = Window:CreateTab("Guest", 4483362458)

-- ======= Main Tab =======
-- Infinite Stamina
local infiniteStamina = false
local function enableInfiniteStamina()
    local success, StaminaModule = pcall(function()
        return require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
    end)
    if not success or not StaminaModule then return end

    StaminaModule.StaminaLossDisabled = true
    task.spawn(function()
        while infiniteStamina and StaminaModule do
            task.wait(0.1)
            StaminaModule.Stamina = StaminaModule.MaxStamina
            StaminaModule.StaminaChanged:Fire()
        end
    end)
end

MainTab:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Callback = function(Value)
        infiniteStamina = Value
        if infiniteStamina then
            enableInfiniteStamina()
        else
            local success, StaminaModule = pcall(function()
                return require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
            end)
            if success and StaminaModule then
                StaminaModule.StaminaLossDisabled = false
            end
        end
    end
})

-- Killer ESP
local KillersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")
local espEnabled = false

local function addESP(obj)
    if not obj:IsA("Model") or not obj:FindFirstChild("HumanoidRootPart") then return end
    if obj:FindFirstChild("ESP_Highlight") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = Color3.fromRGB(255,0,0)
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = obj
    highlight.Parent = obj

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Size = UDim2.new(0,100,0,50)
    billboard.AlwaysOnTop = true
    billboard.Adornee = obj.HumanoidRootPart
    billboard.Parent = obj

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "ESP_Text"
    textLabel.Size = UDim2.new(1,0,1,0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255,0,0)
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
        for _, killer in pairs(KillersFolder:GetChildren()) do clearESP(killer) end
        return
    end
    for _, killer in pairs(KillersFolder:GetChildren()) do addESP(killer) end
end

KillersFolder.ChildAdded:Connect(function(child)
    if espEnabled then task.wait(0.1) addESP(child) end
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

MainTab:CreateToggle({
    Name = "Killer ESP",
    CurrentValue = false,
    Callback = function(Value)
        espEnabled = Value
        refreshESP()
    end
})

-- Infinite Yield
MainTab:CreateButton({
    Name = "Run Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})
MainTab:CreateParagraph({Title = "Tip", Content = 'Run Infinite Yield and type "antifling" so punch fling works better.'})

-- ======= Guest Tab =======
-- Auto Block
local autoBlockOn, autoBlockAudioOn, doubleblocktech, blockTPEnabled = false,false,false,false
local facingCheckEnabled, looseFacing = true,true
local detectionRange, detectionRangeSq = 18, 324

-- Auto Block Toggles
GuestTab:CreateToggle({Name = "Auto Block (Animation)", CurrentValue=false, Callback=function(Value) autoBlockOn=Value end})
GuestTab:CreateToggle({Name = "Auto Block (Audio)", CurrentValue=false, Callback=function(Value) autoBlockAudioOn=Value end})
GuestTab:CreateToggle({Name = "Double Punch Tech", CurrentValue=false, Callback=function(Value) doubleblocktech=Value end})
GuestTab:CreateToggle({Name = "Enable Facing Check", CurrentValue=true, Callback=function(Value) facingCheckEnabled=Value end})
GuestTab:CreateDropdown({Name="Facing Check", Options={"Loose","Strict"}, CurrentOption="Loose", Callback=function(Option) looseFacing = Option=="Loose" end})
GuestTab:CreateInput({Name="Detection Range", PlaceholderText="18", RemoveTextAfterFocusLost=false, Callback=function(Text) detectionRange=tonumber(Text) or detectionRange detectionRangeSq=detectionRange*detectionRange end})
GuestTab:CreateToggle({Name="Block TP", CurrentValue=false, Callback=function(Value) blockTPEnabled=Value end})

-- Fake Block Button
GuestTab:CreateButton({Name="Load Fake Block", Callback=function()
    pcall(function()
        local fakeGui = PlayerGui:FindFirstChild("FakeBlockGui")
        if not fakeGui then
            local success, result = pcall(function()
                return loadstring(game:HttpGet("https://raw.githubusercontent.com/skibidi399/Auto-block-script/main/fakeblock"))()
            end)
            if not success then warn("❌ Failed to load Fake Block GUI:", result) end
        else
            fakeGui.Enabled = true
            print("✅ Fake Block GUI enabled")
        end
    end)
end})

-- Auto Punch
local autoPunchOn, flingPunchOn, aimPunch = false,false,false
local predictionValue, flingPower = 4, 10000

GuestTab:CreateToggle({Name="Auto Punch", CurrentValue=false, Callback=function(Value) autoPunchOn=Value end})
GuestTab:CreateToggle({Name="Fling Punch", CurrentValue=false, Callback=function(Value) flingPunchOn=Value end})
GuestTab:CreateToggle({Name="Punch Aimbot", CurrentValue=false, Callback=function(Value) aimPunch=Value end})
GuestTab:CreateSlider({Name="Aim Prediction", Range={0,10}, Increment=0.1, CurrentValue=predictionValue, Suffix="studs", Callback=function(Value) predictionValue=Value end})
GuestTab:CreateSlider({Name="Fling Power", Range={5000,50000000000000}, Increment=1000000, CurrentValue=flingPower, Callback=function(Value) flingPower=Value end})

-- End of Script
