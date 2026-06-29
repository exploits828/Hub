-- // DEATH WATCHERS | WINDUI COMPATIBLE RE-ENGINE
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

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
    TargetList = {}
}

-- ⚡ GLOBAL COOLDOWN BREAKER (Instant Refire Overrides)
pcall(function()
    hookfunction(wait, function() return RunService.PostSimulation:Wait() end)
    hookfunction(task.wait, function() return RunService.PostSimulation:Wait() end)
    hookfunction(delay, function(_, func) task.spawn(func) end)
    hookfunction(spawn, function(func) task.spawn(func) end)
end)

-- ==========================================================
-- ⚡ PARALLEL COMBAT LOGIC METHODS
-- ==========================================================
local Tycoons = workspace:WaitForChild("Tycoons", 5)
local allowedBases = {Stone=true, Magic=true, Storm=true, Robotic=true}
local excludedBases = {Insanity=true, Giant=true, Dark=true, Spike=true, Web=true, Strong=true}
local toolToBase = {["Energy Sword"]="Stone", ["Staff"]="Magic", ["Axe"]="Storm", ["Fist"]="Robotic"}
local padsByBase = {}
local activeLoops = {}

if Tycoons then
    for _, d in ipairs(Tycoons:GetDescendants()) do
        if d:IsA("TouchTransmitter") and d.Parent and d.Parent.Parent and d.Parent.Parent.Name:find("GearGiver1") then
            local base = d.Parent.Parent.Parent
            if base and not excludedBases[base.Name] and allowedBases[base.Name] then
                padsByBase[base.Name] = padsByBase[base.Name] or {}
                table.insert(padsByBase[base.Name], d.Parent)
            end
        end
    end
end

local function hasSpecificTool(toolName)
    local function scan(c) if not c then return false end for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") and t.Name == toolName then return true end end return false end
    return scan(LP.Backpack) or scan(LP.Character)
end

local function runParallelGrabLoop(toolName)
    if activeLoops[toolName] or not _G.Settings.ToolGrabber then return end
    local base = toolToBase[toolName]
    if not base then return end
    activeLoops[toolName] = true
    task.spawn(function()
        while activeLoops[toolName] and _G.Settings.ToolGrabber do
            if hasSpecificTool(toolName) then activeLoops[toolName] = nil break end
            local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if root and padsByBase[base] then
                for _, pad in ipairs(padsByBase[base]) do
                    for i = 1, 8 do firetouchinterest(root, pad, 0) firetouchinterest(root, pad, 1) end
                end
            end
            RunService.Heartbeat:Wait()
        end
        activeLoops[toolName] = nil
    end)
end

local function triggerQuantumGrab()
    if not _G.Settings.ToolGrabber then return end
    for name in pairs(toolToBase) do runParallelGrabLoop(name) end
end

local pulseAccum = 0
local pulseInterval = 1 / 70

local function equipTools()
    local char, bp = LP.Character, LP.Backpack
    if not char or not bp then return end
    for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") and t.Parent ~= char then t.Parent = char end end
end

local function activateTools()
    local char = LP.Character if not char then return end
    for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then pcall(t.Activate, t) end end
end

-- ==========================================================
-- 🛠️ WINDUI INITIALIZATION FRAMEWORK
-- ==========================================================
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "DEATH WATCHERS",
    Author = "CORE v4",
    Folder = "DeathWatchersConfig",
    Icon = "shield",
    Size = UDim2.fromOffset(540, 380),
    Theme = "Dark",
    Transparent = false,
    HasOutline = true
})

local CombatTab = Window:Tab({ Title = "Combat Mods", Icon = "swords" })
local TargetingTab = Window:Tab({ Title = "Target System", Icon = "crosshair" })

-- ==========================================================
-- 🎛️ COMBAT CONFIGURATION INTERACTION
-- ==========================================================
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
    Callback = function(v)
        _G.Settings.Respawn = v
    end
})

-- ==========================================================
-- 🎯 TARGETING AND RADAR SELECTION INTERACTION
-- ==========================================================
TargetingTab:Toggle({
    Title = "Target Kill Aura Network",
    Value = false,
    Callback = function(v)
        _G.Settings.KillAura = v
    end
})

TargetingTab:Toggle({
    Title = "Refresh Player List Loopbring",
    Value = false,
    Callback = function(v)
        _G.Settings.Loopbring = v
    end
})

TargetingTab:Section({ Title = "Target Profile Matrix" })

local playerNames = {}
local function updatePlayerList()
    table.clear(playerNames)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            table.insert(playerNames, p.Name)
        end
    end
end
updatePlayerList()

local PlayerDropdown = TargetingTab:Dropdown({
    Title = "Select Target Player",
    Desc = "Click a player to toggle Lock-On status",
    Values = playerNames,
    Callback = function(selectedName)
        local p = Players:FindFirstChild(selectedName)
        if p then
            local idx = table.find(getgenv().configs.TargetList, p)
            if idx then
                table.remove(getgenv().configs.TargetList, idx)
                _G.BringTargets[p.Name] = nil
                WindUI:Notify({
                    Title = "Target Disengaged",
                    Content = p.Name .. " dropped from monitoring matrix.",
                    Duration = 3
                })
            else
                table.insert(getgenv().configs.TargetList, p)
                _G.BringTargets[p.Name] = true
                WindUI:Notify({
                    Title = "Target Acquired",
                    Content = p.Name .. " successfully locked into tracking data.",
                    Duration = 3
                })
            end
        end
    end
})

TargetingTab:Button({
    Title = "🔄 Force Manual Player Sync",
    Desc = "Re-scans server registry and populates target choices",
    Callback = function()
        updatePlayerList()
        pcall(function() PlayerDropdown:SetValues(playerNames) end)
        pcall(function() PlayerDropdown:Refresh(playerNames) end)
    end
})

Players.PlayerAdded:Connect(function()
    updatePlayerList()
    pcall(function() PlayerDropdown:SetValues(playerNames) end)
    pcall(function() PlayerDropdown:Refresh(playerNames) end)
end)

Players.PlayerRemoving:Connect(function()
    updatePlayerList()
    pcall(function() PlayerDropdown:SetValues(playerNames) end)
    pcall(function() PlayerDropdown:Refresh(playerNames) end)
end)

-- ==========================================================
-- 🚀 HIGH-VELOCITY REFIRE CORE ENGINE LOOPS
-- ==========================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuideEvent = ReplicatedStorage:FindFirstChild("Guide")
local respawnFired = false

local function executeInstantRespawn()
    if respawnFired or not _G.Settings.Respawn then return end
    respawnFired = true
    local function fire() pcall(function() if GuideEvent then GuideEvent:FireServer() else LP:LoadCharacter() end end) end
    fire() task.delay(0.02, fire) task.delay(0.2, function() respawnFired = false end)
end

local function hookCharacterHumanoid(char)
    local hum = char:WaitForChild("Humanoid", 2) if not hum then return end
    hum.HealthChanged:Connect(function(hp) if _G.Settings.Respawn and hp <= 0 then executeInstantRespawn() end end)
    hum.Died:Connect(function() if _G.Settings.Respawn then executeInstantRespawn() end end)
end

LP.CharacterAdded:Connect(function(char)
    hookCharacterHumanoid(char)
    task.spawn(function()
        char:WaitForChild("HumanoidRootPart", 5)
        if _G.Settings.ToolGrabber then triggerQuantumGrab() end
    end)
end)
if LP.Character then hookCharacterHumanoid(LP.Character) end

RunService.Heartbeat:Connect(function()
    if _G.Settings.UseTools then equipTools() end

    if _G.Settings.Loopbring and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local myRoot = LP.Character.HumanoidRootPart
        for name in pairs(_G.BringTargets) do
            local p = Players:FindFirstChild(name)
            local tRoot = p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if tRoot then
                tRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, -2) * CFrame.Angles(0, math.rad(180), 0)
            end
        end
    end

    if _G.Settings.KillAura and #getgenv().configs.TargetList > 0 and LP.Character then
        local Ignorelist = OverlapParams.new()
        Ignorelist.FilterType = Enum.RaycastFilterType.Include
        local validTargets = {}
        for _, p in ipairs(getgenv().configs.TargetList) do
            if p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then table.insert(validTargets, p.Character) end
        end
        Ignorelist.FilterDescendantsInstances = validTargets

        for _, tool in ipairs(LP.Character:GetChildren()) do
            if tool:IsA("Tool") then
                for _, obj in ipairs(tool:GetDescendants()) do
                    if obj:IsA("TouchTransmitter") then
                        local parts = workspace:GetPartBoundsInBox(obj.Parent.CFrame, obj.Parent.Size + getgenv().configs.Size, Ignorelist)
                        for _, pPart in ipairs(parts) do
                            firetouchinterest(obj.Parent, pPart, 1)
                            firetouchinterest(obj.Parent, pPart, 0)
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
        activateTools()
    end
end)

WindUI:Notify({
    Title = "System Operational",
    Content = "WindUI & Core Loops fully initialized.",
    Duration = 4
})
