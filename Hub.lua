-- /* DEATH WATCHERS CLAN HUB - FULL GODLY ENGINE */
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local Window = Rayfield:CreateWindow({Name = "DEATH WATCHERS CLAN HUB", KeySystem = true, KeySettings = {Key = "DW_SPEED_2026"}})

-- Tabs
local Home = Window:CreateTab("Home", "home")
local TargetTab = Window:CreateTab("Targeting", "crosshair")
local ImmTab = Window:CreateTab("Immunity", "heart")
local AdminTab = Window:CreateTab("Admin", "terminal")
local ServerTab = Window:CreateTab("Server", "server")
local IdTab = Window:CreateTab("Identity", "user")

_G.Settings = {Hitbox=false, Aura=false, Loopbring=false, GodMode=false, Respawn=false, AntiTouch=false}

-- // 1. INSTANT TOOL GRABBER ENGINE
local function grabTools()
    local tycoons = workspace:FindFirstChild("Tycoons")
    if not tycoons then return end
    for _, d in ipairs(tycoons:GetDescendants()) do
        if d:IsA("TouchTransmitter") and d.Parent.Parent.Name:find("GearGiver1") then
            task.spawn(function()
                for i = 1, 8 do
                    firetouchinterest(LP.Character.HumanoidRootPart, d.Parent, 0)
                    firetouchinterest(LP.Character.HumanoidRootPart, d.Parent, 1)
                end
            end)
        end
    end
end

-- // 2. NO-DELAY COMBAT ENGINE
local function autoEquipAndActivate()
    local char = LP.Character
    if not char then return end
    for _, t in ipairs(LP.Backpack:GetChildren()) do
        if t:IsA("Tool") then t.Parent = char end
    end
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") then pcall(function() t:Activate() end) end
    end
end

-- // 3. GOD MODE (Subject Swap)
local function RunGodMode()
    local char = LP.Character
    if char and char:FindFirstChild("Humanoid") then
        local clone = char.Humanoid:Clone()
        clone.Parent = char
        char.Humanoid:Destroy()
        LP.Character = char
        workspace.CurrentCamera.CameraSubject = clone
    end
end

-- // TABS & TOGGLES
Home:CreateToggle({Name="Hitbox Expander", Callback=function(v) _G.Settings.Hitbox=v end})
Home:CreateToggle({Name="Instant Respawn", Callback=function(v) _G.Settings.Respawn=v end})
TargetTab:CreateToggle({Name="Targeted Kill Aura", Callback=function(v) _G.Settings.Aura=v end})
TargetTab:CreateToggle({Name="Loopbring Target", Callback=function(v) _G.Settings.Loopbring=v end})
ImmTab:CreateToggle({Name="Ultimate God Mode", Callback=function(v) if v then RunGodMode() end end})
ImmTab:CreateToggle({Name="Anti-Touch Damage", Callback=function(v) _G.Settings.AntiTouch=v end})
AdminTab:CreateButton({Name="Nameless Admin", Callback=function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Nameless-admin-v250-script-87765"))() end})

-- // MAIN ENGINE LOOP
LP.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    task.spawn(function()
        grabTools() --[cite: 1]
        for i = 1, 5 do
            autoEquipAndActivate() --[cite: 2]
            RunService.Heartbeat:Wait()
        end
    end)
end)

RunService.Heartbeat:Connect(function()
    local lp = LP
    if not lp.Character then return end
    
    autoEquipAndActivate() --[cite: 2, 6]

    if _G.Settings.Hitbox then
        for _,p in pairs(Players:GetPlayers()) do
            if p~=lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
                p.Character.HumanoidRootPart.Size=Vector3.new(10,10,10) 
            end
        end
    end
    
    if _G.Settings.Respawn and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health <= 0 then
        lp:RequestRespawn()
    end
    
    if _G.Settings.AntiTouch then
        for _,part in ipairs(lp.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanTouch=false end
        end
    end
end)
