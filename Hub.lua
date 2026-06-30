--[[
    DEATH WATCHERS CLAN HUB - UNIFIED HUB V8.4
    Theme: WindUI
    Optimized for Vega X & Multi-Matrix Execution
--]]

local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()

local Window = WindUI:CreateWindow({
    Title = "DEATH WATCHERS CLAN HUB",
    SubTitle = "V8.4 - Unified Matrix",
    Author = "DEATH WATCHERS",
    Folder = "DeathWatchersConfig_V8",
    Icon = "rbxassetid://10723343321" -- Custom clan hub asset icon
})

-- ==========================================
-- CONFIGURATION & STATE
-- ==========================================
local Config = {
    HitboxSize = 25,
    HitboxTransparency = 0.7,
    KillAuraEnabled = false,
    KillAuraRange = 15,
    ToolGrabberEnabled = false
}

-- Target filtering strictly matching verified screenshots
local targetWeapons = {
    ["Storm Tycoon"] = "Axe",         -- Screenshot_20260630-013938.jpg
    ["Robotic Tycoon"] = "Fists",     -- Screenshot_20260630-014100.jpg (Excludes generic variants)
    ["Stone Tycoon"] = "Energy Sword", -- Screenshot_20260630-014124.jpg
    ["Magic Tycoon"] = "Staff"        -- Screenshot_20260630-014206.jpg
}

-- ==========================================
-- CORE FUNCTIONS
-- ==========================================

-- Specialized Quantum Tool Grabber
local function grabQuantumTools()
    local tycoons = workspace:FindFirstChild("Tycoons")
    if not tycoons then return end

    for tycoonName, weaponName in pairs(targetWeapons) do
        local tycoon = tycoons:FindFirstChild(tycoonName)
        if tycoon then
            for _, item in ipairs(tycoon:GetDescendants()) do
                if item:IsA("TouchTransmitter") and item.Parent and item.Parent.Name == weaponName then
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, item.Parent, 0)
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, item.Parent, 1)
                end
            end
        end
    end
end

-- Instant Equip Engine (Zero Delay for Spawn Protection)
local function instantEquipTools()
    local character = game.Players.LocalPlayer.Character
    local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")
    
    if character and backpack then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    humanoid:EquipTool(tool)
                end
            end
        end
    end
end

-- Vega X Optimized Combat Loop Engine
task.spawn(function()
    while true do
        task.wait(0.1) -- Stable tickrate to prevent execution engine crashes
        
        local localPlayer = game.Players.LocalPlayer
        local char = localPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            
            -- Tool Auto-Grab Loop
            if Config.ToolGrabberEnabled then
                grabQuantumTools()
            end
            
            -- Kill Aura Mechanics
            if Config.KillAuraEnabled then
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (char.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if distance <= Config.KillAuraRange and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                            local weapon = char:FindFirstChildOfClass("Tool")
                            if weapon then
                                weapon:Activate()
                            end
                        end
                    end
                end
            end
            
        end
    end
end)

-- ==========================================
-- UI TABS & CONTROLS (WindUI Layout)
-- ==========================================

-- 1. Combat Tab
local CombatTab = Window:CreateTab({
    Title = "Combat Options",
    Icon = "rbxassetid://10734950339"
})

CombatTab:CreateToggle({
    Title = "Kill Aura (Vega X Optimized)",
    Desc = "Automatically attacks nearby targets",
    Value = false,
    Callback = function(Value)
        Config.KillAuraEnabled = Value
    end
})

CombatTab:CreateSlider({
    Title = "Kill Aura Range",
    Desc = "Adjust the range for automatic attacks",
    Min = 5,
    Max = 30,
    Value = 15,
    Callback = function(Value)
        Config.KillAuraRange = Value
    end
})

-- 2. Hitbox Tab
local HitboxTab = Window:CreateTab({
    Title = "Hitbox Expander",
    Icon = "rbxassetid://10723346959"
})

HitboxTab:CreateButton({
    Title = "Expand Hitboxes",
    Desc = "Resize opponent positions instantly",
    Callback = function()
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                hrp.Transparency = Config.HitboxTransparency
                hrp.BrickColor = BrickColor.new("Really blue")
                hrp.Material = Enum.Material.Neon
                hrp.CanCollide = false
            end
        end
    end
})

HitboxTab:CreateSlider({
    Title = "Hitbox Size",
    Desc = "Set target area diameter",
    Min = 2,
    Max = 50,
    Value = 25,
    Callback = function(Value)
        Config.HitboxSize = Value
    end
})

-- 3. Automation Tab
local AutomationTab = Window:CreateTab({
    Title = "Automation",
    Icon = "rbxassetid://10723351915"
})

AutomationTab:CreateToggle({
    Title = "Targeted Quantum Tool Grabber",
    Desc = "Strictly targets weapons from your verified screenshot locations",
    Value = false,
    Callback = function(Value)
        Config.ToolGrabberEnabled = Value
        if Value then
            grabQuantumTools()
        end
    end
})

-- ==========================================
-- LIFECYCLE HOOKS
-- ==========================================
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    
    -- Triggers instantly upon instantiation to bypass spawn campers (Zero Delay)
    if Config.ToolGrabberEnabled then
        grabQuantumTools()
        instantEquipTools()
    end
end)

-- WindUI Notification System
WindUI:Notify({
    Title = "Hub Initialized",
    Content = "WindUI V8.4 is fully loaded and optimized.",
    Duration = 5
})
