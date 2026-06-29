-- // DEATH WATCHERS | ULTIMATE PVP HUBS ENGINE
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/Example.lua"))()
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- Initialize Main Window Container with Fine Blue Accent Edging
local Window = WindUI:CreateWindow({
    Title = "DEATH WATCHERS | PVP MATRIX",
    Icon = "rbxassetid://128278170341835",
    Author = "DW Clan Core",
    Folder = "DeathWatchers_WindUI",
    Size = UDim2.fromOffset(600, 480),
    Transparent = false,
    HasOutline = true,
    Theme = "Dark"
})

-- ==========================================================
-- 🛠️ SYSTEM REGISTRIES & CORE STATE HARNESS
-- ==========================================================
_G.Settings = {
    UseTools = false,
    Respawn = false,
    ToolGrabber = true,
    Loopbring = false,
    KillAura = false
}

_G.BringTargets = {}
getgenv().configs = {
    connections = {},
    Size = Vector3.new(30, 30, 30),
    TargetList = {} -- Syncs with the Targeting Aura network
}

-- ⚡ [SOURCE 14] GLOBAL COOLDOWN BREAKER (Instant Refire Overrides)
pcall(function()
    hookfunction(wait, function() return RunService.PostSimulation:Wait() end)
    hookfunction(task.wait, function() return RunService.PostSimulation:Wait() end)
    hookfunction(delay, function(_, func) task.spawn(func) end)
    hookfunction(spawn, function(func) task.spawn(func) end)
end)

-- ==========================================================
-- ⚡ [SOURCE 11] QUANTUM PARALLEL TOOL GRABBER ENGINE
-- ==========================================================
local Tycoons = workspace:WaitForChild("Tycoons", 5)
local allowedBases = {Stone=true, Magic=true, Storm=true, Robotic=true}
local excludedBases = {Insanity=true, Giant=true, Dark=true, Spike=true, Web=true, Strong=true}
local toolToBase = {
    ["Energy Sword"] = "Stone",
    ["Staff"] = "Magic",
    ["Axe"] = "Storm",
    ["Fist"] = "Robotic",
}
local padsByBase = {}
local activeLoops = {}

local function registerPad(pad)
    local base = pad.Parent and pad.Parent.Parent
    if not base or excludedBases[base.Name] or not allowedBases[base.Name] then return end
    padsByBase[base.Name] = padsByBase[base.Name] or {}
    table.insert(padsByBase[base.Name], pad)
end

if Tycoons then
    for _, d in ipairs(Tycoons:GetDescendants()) do
        if d:IsA("TouchTransmitter") and d.Parent and d.Parent.Parent and d.Parent.Parent.Name:find("GearGiver1") then
            registerPad(d.Parent)
        end
    end
end

local function hasSpecificTool(toolName)
    local function scan(container)
        if not container then return false end
        for _, t in ipairs(container:GetChildren()) do
            if t:IsA("Tool") and t.Name == toolName then return true end
        end
        return false
    end
    return scan(LP.Backpack) or scan(LP.Character)
end

local function runParallelGrabLoop(toolName)
    if activeLoops[toolName] or not _G.Settings.ToolGrabber then return end
    local base = toolToBase[toolName]
    if not base then return end

    activeLoops[toolName] = true
    task.spawn(function()
        while activeLoops[toolName] and _G.Settings.ToolGrabber do
            if hasSpecificTool(toolName) then
                activeLoops[toolName] = nil
                break
            end
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root and padsByBase[base] then
                for _, pad in ipairs(padsByBase[base]) do
                    for i = 1, 8 do -- Burst touch execution frame
                        firetouchinterest(root, pad, 0)
                        firetouchinterest(root, pad, 1)
                    end
                end
            end
            RunService.Heartbeat:Wait()
        end
        activeLoops[toolName] = nil
    end)
end

local function triggerQuantumGrab()
    if not _G.Settings.ToolGrabber then return end
    for toolName in pairs(toolToBase) do
        runParallelGrabLoop(toolName)
    end
end

-- ==========================================================
-- ⚔️ [SOURCE 12] HEADLESS RTX ULTRA USE TOOLS ENGINE
-- ==========================================================
local pulseAccum = 0
local pulseInterval = 1 / 70 -- High-frequency performance clock

local function equipTools()
    local char, bp = LP.Character, LP.Backpack
    if not char or not bp then return end
    for _, t in ipairs(bp:GetChildren()) do
        if t:IsA("Tool") and t.Parent ~= char then
            t.Parent = char
        end
    end
end

local function activateTools()
    local char = LP.Character
    if not char then return end
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") then
            pcall(t.Activate, t)
        end
    end
end

-- ==========================================================
-- 💀 [SOURCE 13] QUANTUM PRE-DEATH RESPAWN ENGINE
-- ==========================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuideEvent = ReplicatedStorage:FindFirstChild("Guide")
local respawnFired = false

local function executeInstantRespawn()
    if respawnFired or not _G.Settings.Respawn then return end
    respawnFired = true
    
    local function fire()
        pcall(function()
            if GuideEvent then GuideEvent:FireServer() else LP:LoadCharacter() end
        end)
    end
    fire()
    task.delay(0.02, fire) -- Backup verification shot
    task.delay(0.2, function() respawnFired = false end)
end

local function hookCharacterHumanoid(char)
    local hum = char:WaitForChild("Humanoid", 2)
    if not hum then return end
    hum.HealthChanged:Connect(function(hp)
        if _G.Settings.Respawn and hp <= 0 then executeInstantRespawn() end
    end)
    hum.Died:Connect(function()
        if _G.Settings.Respawn then executeInstantRespawn() end
    end)
end

-- ==========================================================
-- 🎨 DESIGN LAYER & PERFECTLY SPACED UI SECTIONS
-- ==========================================================
local CombatTab = Window:Tab({Title = "PvP", Icon = "sword"})
local TargetTab = Window:Tab({Title = "Targeting", Icon = "crosshair"})
local AdminTab = Window:Tab({Title = "Admin", Icon = "terminal"})
local InfoTab  = Window:Tab({Title = "Identity", Icon = "user"})

-- --- PVP TAB CONFIGURATION ---
CombatTab:Section({Title = "⚡ Automated Combat Systems"})

CombatTab:Toggle({
    Title = "RTX Instant Auto-Use Tools",
    Value = false,
    Callback = function(v) 
        _G.Settings.UseTools = v 
        if v then equipTools() end
    end
})

CombatTab:Toggle({
    Title = "Quantum Parallel Tool Grabber",
    Value = true,
    Callback = function(v) 
        _G.Settings.ToolGrabber = v 
        if v then triggerQuantumGrab() end
    end
})

CombatTab:Toggle({
    Title = "Pre-Death Instant Respawn Engine",
    Value = false,
    Callback = function(v) _G.Settings.Respawn = v end
})

-- --- ADMIN & IDENTITY MODULES ---
AdminTab:Section({Title = "🛠️ Operational Overrides"})
AdminTab:Button({
    Title = "Load Nameless Admin Tools",
    Callback = function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Nameless-admin-v250-script-87765"))() end
})

InfoTab:Section({Title = "👤 Local Client Signatures"})
InfoTab:Label({Title = "Player Identity: " .. LP.Name})
InfoTab:Label({Title = "Network Account ID: " .. LP.UserId})

-- ==========================================================
-- 🎯 DYNAMIC TARGETING INTERFACE WITH DEDICATED ROSTER
-- ==========================================================
TargetTab:Section({Title = "⚔️ Combat Routing Triggers"})

local AuraToggle = TargetTab:Toggle({
    Title = "Targeted Kill Aura Network",
    Value = false,
    Callback = function(v) _G.Settings.KillAura = v end
})

local LoopbringToggle = TargetTab:Toggle({
    Title = "Loopbring Target Vector",
    Value = false,
    Callback = function(v) _G.Settings.Loopbring = v end
})

-- Dynamic Layout Containers for Target Assignment Frame
local TargetListSection = TargetTab:Section({Title = "🎯 Active Network Roster Selector"})

local function populatePlayerTargetElements()
    -- Cleans structural content row rows safely to avoid rendering duplication
    for _, element in ipairs(TargetTab:GetChildren()) do
        if element.Title and element.Title ~= "⚔️ Combat Routing Triggers" and element.Title ~= "🎯 Active Network Roster Selector" and not element.Title:find("Aura") and not element.Title:find("Loopbring") then
            element:Destroy()
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local isAuraTarget = table.find(getgenv().configs.TargetList, p) ~= nil
            local isLoopTarget = _G.BringTargets[p.Name] ~= nil
            
            local statusText = "[ Neutral Status ]"
            if isAuraTarget and isLoopTarget then statusText = "[ AURA + LOOPING ]"
            elseif isAuraTarget then statusText = "[ AURA ACTIVE ]"
            elseif isLoopTarget then statusText = "[ LOOP ACTIVE ]" Required end

            TargetTab:Button({
                Title = p.DisplayName .. " (@" .. p.Name .. ") " .. statusText,
                Callback = function()
                    -- Multi-Select routing matrix integration
                    local auraIdx = table.find(getgenv().configs.TargetList, p)
                    if auraIdx then
                        table.remove(getgenv().configs.TargetList, auraIdx)
                        _G.BringTargets[p.Name] = nil
                    else
                        table.insert(getgenv().configs.TargetList, p)
                        _G.BringTargets[p.Name] = true
                    end
                    populatePlayerTargetElements() -- Dynamic Roster Update
                end
            })
        end
    end
end

TargetTab:Button({
    Title = "🔄 Refresh Target Player List",
    Callback = function() populatePlayerTargetElements() end
})

populatePlayerTargetElements()
Players.PlayerAdded:Connect(populatePlayerTargetElements)
Players.PlayerRemoving:Connect(populatePlayerTargetElements)

-- ==========================================================
-- 🚀 HIGH-VELOCITY CORE RUNTIME SYNCHRONIZATION
-- ==========================================================
local spawnHandled = false

local function runInstantSpawnSetup(char)
    spawnHandled = false
    task.spawn(function()
        char:WaitForChild("HumanoidRootPart", 5)
        if spawnHandled then return end
        spawnHandled = true
        
        if _G.Settings.ToolGrabber then triggerQuantumGrab() end[cite: 11]
        if _G.Settings.UseTools then
            equipTools()[cite: 12]
            for i = 1, 3 do
                activateTools()[cite: 12]
                RunService.Heartbeat:Wait()
            end
        end
    end)
end

LP.CharacterAdded:Connect(function(char)
    hookCharacterHumanoid(char)
    runInstantSpawnSetup(char)
end)
if LP.Character then 
    hookCharacterHumanoid(LP.Character) 
    runInstantSpawnSetup(LP.Character)
end

-- Persistent Loop Harness running directly inside frame cycles
RunService.Heartbeat:Connect(function(dt)
    if _G.Settings.UseTools then equipTools() end[cite: 12]

    -- [SOURCE 16] Loopbring Vector Engine Execution
    if _G.Settings.Loopbring and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local myRoot = LP.Character.HumanoidRootPart
        for name in pairs(_G.BringTargets) do
            local p = Players:FindFirstChild(name)
            local tRoot = p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if tRoot then
                local targetPosition = myRoot.Position + (myRoot.CFrame.LookVector * 2)
                tRoot.CFrame = CFrame.new(targetPosition, myRoot.Position) * CFrame.Angles(0, math.rad(180), 0)[cite: 16]
            end
        end
    end

    -- [SOURCE 17] Kill Aura Network Engine
    if _G.Settings.KillAura and #getgenv().configs.TargetList > 0 and LP.Character then
        local Ignorelist = OverlapParams.new()
        Ignorelist.FilterType = Enum.RaycastFilterType.Include
        
        local validTargets = {}
        for _, p in ipairs(getgenv().configs.TargetList) do
            if p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                table.insert(validTargets, p.Character)
            end
        end
        Ignorelist.FilterDescendantsInstances = validTargets

        for _, tool in ipairs(LP.Character:GetChildren()) do
            if tool:IsA("Tool") then
                for _, obj in ipairs(tool:GetDescendants()) do
                    if obj:IsA("TouchTransmitter") and obj.Parent:IsA("BasePart") then
                        local touch = obj.Parent
                        local parts = workspace:GetPartBoundsInBox(touch.CFrame, touch.Size + getgenv().configs.Size, Ignorelist)[cite: 17]
                        for _, pPart in ipairs(parts) do
                            local charAncestor = pPart:FindFirstAncestorWhichIsA("Model")
                            if charAncestor and tool:IsDescendantOf(workspace) then
                                firetouchinterest(touch, pPart, 1)[cite: 17]
                                firetouchinterest(touch, pPart, 0)[cite: 17]
                            end
                        end
                    end
                end
            end
        end
    end
end)

RunService.PreSimulation:Connect(function(dt)
    if not _G.Settings.UseTools then return end
    pulseAccum = pulseAccum + dt
    while pulseAccum >= pulseInterval do
        pulseAccum = pulseAccum - pulseInterval
        activateTools()[cite: 12]
    end
end)

print("⚡ Clean Structured PvP Matrix Hub Ready & Loaded Spotlessly.")
