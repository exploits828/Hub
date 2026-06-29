-- // DEATH WATCHERS | ULTIMATE PVP MATRIX ENGINE (WINDUI PRODUCTION V8.1)
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")
local LP = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui") or LP:WaitForChild("PlayerGui")

-- Initialize Main Window Container with WindUI Dark Interface Framework
local Window = WindUI:CreateWindow({
    Title = "DEATH WATCHERS | MULTI-MATRIX",
    Icon = "shield",
    Author = "DW Clan Core",
    Folder = "DeathWatchers_WindUI",
    Size = UDim2.fromOffset(580, 520),
    Transparent = false,
    HasOutline = true,
    Theme = "Dark"
})

-- ==========================================================
-- 🛠️ SYSTEM REGISTRIES & CORE STATE HARNESS
-- ==========================================================
_G.Settings = {
    UseTools = false, Respawn = false, ToolGrabber = true, Loopbring = false,
    KillAura = false, HitboxExpander = false, HitboxSize = 12, HitAmplifier = false,
    ToolFollow = false, ZeroCooldown = false
}

_G.BringTargets = {}
getgenv().configs = { connections = {}, Size = Vector3.new(30, 30, 30), TargetList = {} }
local modifiedHitboxes, cachedToolParts, cachedTargetTorsos = {}, {}, {}

-- ⚡ DYNAMIC 0 COOLDOWN BREAKER HOOK ENGINE
local oWait, oTWait, oDelay, oSpawn
pcall(function()
    oWait = hookfunction(wait, function(...) if _G.Settings.ZeroCooldown then return RunService.PostSimulation:Wait() else return oWait(...) end end)
    oTWait = hookfunction(task.wait, function(...) if _G.Settings.ZeroCooldown then return RunService.PostSimulation:Wait() else return oTWait(...) end end)
    oDelay = hookfunction(delay, function(t, func) if _G.Settings.ZeroCooldown then return task.spawn(func) else return oDelay(t, func) end end)
    oSpawn = hookfunction(spawn, function(func) if _G.Settings.ZeroCooldown then return task.spawn(func) else return oSpawn(func) end end)
end)

-- ==========================================================
-- ⚡ PARALLEL COMBAT ASSISTANCE LOGIC METHODS
-- ==========================================================
local Tycoons = workspace:WaitForChild("Tycoons", 5)
local allowedBases = {Stone=true, Magic=true, Storm=true, Robotic=true}
local excludedBases = {Insanity=true, Giant=true, Dark=true, Spike=true, Web=true, Strong=true}
local toolToBase = {["Energy Sword"]="Stone", ["Staff"]="Magic", ["Axe"]="Storm", ["Fist"]="Robotic"}
local padsByBase, activeLoops = {}, {}

local function registerPad(pad)
    local base = pad.Parent and pad.Parent.Parent
    if not base or excludedBases[base.Name] or not allowedBases[base.Name] then return end
    padsByBase[base.Name] = padsByBase[base.Name] or {}
    table.insert(padsByBase[base.Name], pad)
end

if Tycoons then
    for _, d in ipairs(Tycoons:GetDescendants()) do
        if d:IsA("TouchTransmitter") and d.Parent and d.Parent.Parent and d.Parent.Parent.Name:find("GearGiver1") then registerPad(d.Parent) end
    end
end

local function hasSpecificTool(toolName)
    local function scan(container)
        if not container then return false end
        for _, t in ipairs(container:GetChildren()) do if t:IsA("Tool") and t.Name == toolName then return true end end
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
            if hasSpecificTool(toolName) then activeLoops[toolName] = nil break end
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
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
    for toolName in pairs(toolToBase) do runParallelGrabLoop(toolName) end
end

-- ==========================================================
-- 🛡️ TOOL PHYSICS & TORSO PACK CACHING
-- ==========================================================
local function getToolPart(tool)
    if tool:FindFirstChild("Handle") and tool.Handle:IsA("BasePart") then return tool.Handle end
    if tool.PrimaryPart and tool.PrimaryPart:IsA("BasePart") then return tool.PrimaryPart end
    for _, v in ipairs(tool:GetDescendants()) do if v:IsA("BasePart") then return v end end return nil
end

local function updateToolCache()
    table.clear(cachedToolParts)
    if not LP.Character then return end
    for _, tool in ipairs(LP.Character:GetChildren()) do
        if tool:IsA("Tool") then local part = getToolPart(tool) if part then table.insert(cachedToolParts, part) end end
    end
end

local function fixToolPhysics(tool)
    if tool:IsA("Tool") then
        tool.GripPos = Vector3.new(0, 0, 0)
        local part = getToolPart(tool)
        if part then part.CanCollide = false part.Massless = true end
    end
end

-- ==========================================================
-- ⚔️ HEADLESS RTX ULTRA USE TOOLS ENGINE
-- ==========================================================
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
-- 💀 QUANTUM PRE-DEATH RESPAWN ENGINE
-- ==========================================================
local GuideEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Guide")
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

-- ==========================================================
-- 👁️ OVERWATCH SPECTATOR ENGINE
-- ==========================================================
local spectating = false
local specIndex = 1
local specPlayers = {}
local specGui = nil

local function updateSpectateTarget()
    if not spectating then return end
    specPlayers = Players:GetPlayers()
    if #specPlayers <= 1 then return end

    if specIndex > #specPlayers then specIndex = 1 end
    if specIndex < 1 then specIndex = #specPlayers end

    local target = specPlayers[specIndex]
    if target == LP then
        specIndex = specIndex + 1
        if specIndex > #specPlayers then specIndex = 1 end
        target = specPlayers[specIndex]
    end

    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
        workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
        if specGui and specGui:FindFirstChild("MainFrame") then
            specGui.MainFrame.NameLabel.Text = "Spying: " .. target.DisplayName .. " (@" .. target.Name .. ")"
        end
    else
        if specGui and specGui:FindFirstChild("MainFrame") then
            specGui.MainFrame.NameLabel.Text = "Spying: " .. target.Name .. " (DEAD/LOADING)"
        end
    end
end

local function stopSpectating()
    spectating = false
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        workspace.CurrentCamera.CameraSubject = LP.Character.Humanoid
    end
    if specGui then specGui:Destroy() specGui = nil end
end

local function startSpectating()
    if spectating then return end
    spectating = true
    specIndex = 1

    pcall(function() if CoreGui:FindFirstChild("DW_SpectatorHUD") then CoreGui.DW_SpectatorHUD:Destroy() end end)

    specGui = Instance.new("ScreenGui")
    specGui.Name = "DW_SpectatorHUD"
    specGui.ResetOnSpawn = false
    
    local success = pcall(function() specGui.Parent = CoreGui end)
    if not success then specGui.Parent = LP:WaitForChild("PlayerGui") end

    local frame = Instance.new("Frame", specGui)
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 400, 0, 50)
    frame.Position = UDim2.new(0.5, -200, 1, -120)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local nameLabel = Instance.new("TextLabel", frame)
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, -100, 1, 0)
    nameLabel.Position = UDim2.new(0, 50, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = "Initializing..."

    local prevBtn = Instance.new("TextButton", frame)
    prevBtn.Size = UDim2.new(0, 40, 1, -10)
    prevBtn.Position = UDim2.new(0, 5, 0, 5)
    prevBtn.Text = "<<"
    prevBtn.TextColor3 = Color3.new(1,1,1)
    prevBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    prevBtn.Font = Enum.Font.GothamBold
    prevBtn.TextSize = 18
    Instance.new("UICorner", prevBtn).CornerRadius = UDim.new(0, 6)
    
    local nextBtn = Instance.new("TextButton", frame)
    nextBtn.Size = UDim2.new(0, 40, 1, -10)
    nextBtn.Position = UDim2.new(1, -45, 0, 5)
    nextBtn.Text = ">>"
    nextBtn.TextColor3 = Color3.new(1,1,1)
    nextBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    nextBtn.Font = Enum.Font.GothamBold
    nextBtn.TextSize = 18
    Instance.new("UICorner", nextBtn).CornerRadius = UDim.new(0, 6)

    local stopBtn = Instance.new("TextButton", specGui)
    stopBtn.Size = UDim2.new(0, 120, 0, 30)
    stopBtn.Position = UDim2.new(0.5, -60, 1, -60)
    stopBtn.Text = "STOP SPY"
    stopBtn.TextColor3 = Color3.new(1, 0.2, 0.2)
    stopBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextSize = 16
    Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 6)

    prevBtn.MouseButton1Click:Connect(function() specIndex = specIndex - 1 updateSpectateTarget() end)
    nextBtn.MouseButton1Click:Connect(function() specIndex = specIndex + 1 updateSpectateTarget() end)
    stopBtn.MouseButton1Click:Connect(stopSpectating)

    updateSpectateTarget()
end

-- ==========================================================
-- 🎨 WINDUI DASHBOARD TABS CONFIGURATION
-- ==========================================================
local CombatTab  = Window:Tab({ Title = "PvP Mods", Icon = "swords" })
local GlitchTab  = Window:Tab({ Title = "Tycoon Glitch", Icon = "zap" })
local TargetTab  = Window:Tab({ Title = "Targeting", Icon = "crosshair" })
local AdminTab   = Window:Tab({ Title = "Admin", Icon = "terminal" })
local ServerTab  = Window:Tab({ Title = "Server Info", Icon = "server" })
local InfoTab    = Window:Tab({ Title = "Identity", Icon = "user" })

-- --- 1. PvP COMBAT MODS ---
CombatTab:Section({ Title = "⚡ Core Automation Engines" })
CombatTab:Toggle({ Title = "0 Cooldown Breaker", Value = false, Callback = function(v) _G.Settings.ZeroCooldown = v end })
CombatTab:Toggle({ Title = "RTX Instant Auto-Use Tools", Value = false, Callback = function(v) _G.Settings.UseTools = v if v then equipTools() end end })
CombatTab:Toggle({ Title = "Quantum Parallel Tool Grabber", Value = true, Callback = function(v) _G.Settings.ToolGrabber = v if v then triggerQuantumGrab() end end })
CombatTab:Toggle({ Title = "Pre-Death Instant Respawn Engine", Value = false, Callback = function(v) _G.Settings.Respawn = v end })

CombatTab:Section({ Title = "⚔️ Advanced Combat Multipliers" })
CombatTab:Toggle({
    Title = "Optimized Hitbox Expander V2",
    Value = false,
    Callback = function(v) 
        _G.Settings.HitboxExpander = v 
        if not v then
            for hrp, _ in pairs(modifiedHitboxes) do
                pcall(function()
                    if hrp and hrp.Parent then
                        hrp.Size = Vector3.new(2, 2, 2)
                        hrp.Transparency = 0
                        local vis = hrp:FindFirstChild("HitboxVisual") if vis then vis:Destroy() end
                    end
                end)
            end
            table.clear(modifiedHitboxes)
        end
    end
})
CombatTab:Slider({ Title = "Hitbox Dimension Radius", Min = 2, Max = 30, Value = 12, Callback = function(v) _G.Settings.HitboxSize = v end })
CombatTab:Toggle({ Title = "Ultra Smart Hit Amplifier", Value = false, Callback = function(v) _G.Settings.HitAmplifier = v end })
CombatTab:Toggle({
    Title = "Zero-Gravity Torso Tool Follow",
    Value = false,
    Callback = function(v) 
        _G.Settings.ToolFollow = v 
        if not v then
            pcall(function()
                for _, part in ipairs(cachedToolParts) do
                    local bv = part:FindFirstChildOfClass("BodyVelocity")
                    local bp = part:FindFirstChildOfClass("BodyPosition")
                    if bv then bv:Destroy() end if bp then bp:Destroy() end
                end
            end)
        end
    end
})

-- --- 2. TYCOON GLITCH ENVIRONMENT ---
GlitchTab:Section({ Title = "🌀 Server Rejoin Persistence Engine" })
GlitchTab:Button({
    Title = "⚡ Super Fast Same-Server Rejoin",
    Desc = "Force reconnects to this exact Server JobID to break tycoon unclaiming.",
    Callback = function()
        pcall(function()
            WindUI:Notify({ Title = "Initiating Teleport", Content = "Locking into same instance network...", Duration = 3 })
            task.wait(0.1)
            if #Players:GetPlayers() <= 1 then TeleportService:Teleport(game.PlaceId, LP) else TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP) end
        end)
    end
})
GlitchTab:Section({ Title = "💡 How to Use the Tycoon Glitch" })
GlitchTab:Paragraph({ Title = "Execution Method:", Content = "1. Claim your first tycoon normally.\n2. Click 'Super Fast Same-Server Rejoin'.\n3. Because your character disconnects and re-authenticates inside milliseconds, the server cache delays clearing your old claim.\n4. When you land back in, quickly run to a second open tycoon and claim it!" })

-- --- 3. DETAILED SERVER SECTION ---
ServerTab:Section({ Title = "👁️ Overwatch Intelligence" })
ServerTab:Button({
    Title = "Spy on Players (Spectator Mode)",
    Desc = "Deploys a bottom HUD to cycle cameras through active players.",
    Callback = function() startSpectating() end
})

ServerTab:Section({ Title = "🖥️ Live Environment Telemetry" })
local PlayerCountCard = ServerTab:Button({ Title = "Active Roster: Fetching...", Desc = "Total players currently connected" })
local PingCard        = ServerTab:Button({ Title = "Network Latency: Fetching...", Desc = "Real-time client response ping" })
local FpsCard         = ServerTab:Button({ Title = "Core Frame Rate: Fetching...", Desc = "Render performance speed" })
local ServerTimeCard  = ServerTab:Button({ Title = "Server Runtime: Fetching...", Desc = "Elapsed time since instance startup" })

ServerTab:Section({ Title = "Bases & Instances" })
ServerTab:Button({ Title = "Copy Server Job Identification ID", Desc = "Click to save game.JobId to local clipboard", Callback = function() setclipboard(game.JobId) end })

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            PlayerCountCard:SetTitle("Active Roster: " .. #Players:GetPlayers() .. " / " .. Players.MaxPlayers)
            local ping = math.round(Stats.Network.ServerToClientPing:GetValue() * 1000)
            PingCard:SetTitle("Network Latency: " .. ping .. " ms")
            local fps = math.round(1 / RunService.Heartbeat:Wait())
            FpsCard:SetTitle("Core Frame Rate: " .. fps .. " FPS")
            local uptime = math.round(workspace.DistributedGameTime)
            local hours = math.floor(uptime / 3600)
            local minutes = math.floor((uptime % 3600) / 60)
            local seconds = uptime % 60
            ServerTimeCard:SetTitle(string.format("Server Runtime: %02dh : %02dm : %02ds", hours, minutes, seconds))
        end)
    end
end)

-- --- 4. ADMIN UTILITIES ---
AdminTab:Section({ Title = "🛠️ Operational Overrides" })
AdminTab:Button({ Title = "Load Nameless Admin Tools", Desc = "Executes the universal high-privilege administrative script environment", Callback = function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Nameless-admin-v250-script-87765"))() end })

-- --- 5. IDENTITY PROFILE ---
InfoTab:Section({ Title = "👤 Local Client Signatures" })
InfoTab:Button({ Title = "Player Identity: " .. LP.Name, Desc = "Click to copy username to clipboard", Callback = function() setclipboard(LP.Name) end })
InfoTab:Button({ Title = "Network Account ID: " .. LP.UserId, Desc = "Click to copy user identification number", Callback = function() setclipboard(tostring(LP.UserId)) end })

-- ==========================================================
-- 🎯 DYNAMIC TARGETING SYSTEMS INTERFACE
-- ==========================================================
TargetTab:Section({ Title = "⚔️ Combat Routing Triggers" })
TargetTab:Toggle({ Title = "Targeted Kill Aura Network", Value = false, Callback = function(v) _G.Settings.KillAura = v end })
TargetTab:Toggle({ Title = "Loopbring Target Vector", Value = false, Callback = function(v) _G.Settings.Loopbring = v end })
TargetTab:Section({ Title = "🎯 Active Network Roster Selector" })

local pageScrollingContainer = nil
for _, instance in pairs(TargetTab) do
    if typeof(instance) == "Instance" and instance:IsA("ScrollingFrame") then pageScrollingContainer = instance break end
end

local function populatePlayerTargetElements()
    if pageScrollingContainer then
        for _, child in ipairs(pageScrollingContainer:GetChildren()) do
            if child.Name:find("DWTarget_") then child:Destroy() end
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local isAuraTarget = table.find(getgenv().configs.TargetList, p) ~= nil
            local isLoopTarget = _G.BringTargets[p.Name] ~= nil
            
            local statusText = "[ Neutral Status ]"
            if isAuraTarget and isLoopTarget then statusText = "[ AURA + LOOPING ]"
            elseif isAuraTarget then statusText = "[ AURA ACTIVE ]"
            elseif isLoopTarget then statusText = "[ LOOP ACTIVE ]" end

            TargetTab:Button({
                Title = p.DisplayName .. " (@" .. p.Name .. ") " .. statusText,
                Desc = "Click to toggle this player inside global kill matrix networks.",
                Callback = function()
                    local auraIdx = table.find(getgenv().configs.TargetList, p)
                    if auraIdx then
                        table.remove(getgenv().configs.TargetList, auraIdx)
                        _G.BringTargets[p.Name] = nil
                        WindUI:Notify({ Title = "Target Update", Content = p.Name .. " completely disengaged.", Duration = 2 })
                    else
                        table.insert(getgenv().configs.TargetList, p)
                        _G.BringTargets[p.Name] = true
                        WindUI:Notify({ Title = "Target Locked", Content = p.Name .. " routed into tracking loop.", Duration = 2 })
                    end
                    populatePlayerTargetElements()
                end
            })

            if pageScrollingContainer then
                local elements = pageScrollingContainer:GetChildren()
                local newestFrame = elements[#elements]
                if newestFrame and newestFrame:IsA("Frame") and newestFrame.Name == "Frame" then
                    newestFrame.Name = "DWTarget_" .. p.Name
                end
            end
        end
    end
end

TargetTab:Button({ Title = "🔄 Refresh Target Player List", Desc = "Forces manual layout rebuild and updates visibility tags", Callback = function() populatePlayerTargetElements() end })

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
        
        updateToolCache()
        for _, t in ipairs(char:GetChildren()) do fixToolPhysics(t) end
        
        char.ChildAdded:Connect(function(c)
            if c:IsA("Tool") then
                task.wait() updateToolCache() fixToolPhysics(c)
            end
        end)
        if _G.Settings.ToolGrabber then triggerQuantumGrab() end
    end)
end

LP.CharacterAdded:Connect(function(char) hookCharacterHumanoid(char) runInstantSpawnSetup(char) end)
if LP.Character then hookCharacterHumanoid(LP.Character) runInstantSpawnSetup(LP.Character) end
LP.Backpack.ChildAdded:Connect(function(tool) if tool:IsA("Tool") then tool.AncestryChanged:Connect(function() if tool.Parent == LP.Character then fixToolPhysics(tool) end end) end end)

local ampAccumulator, ampScanRate = 0, 1 / 90
local ampOverlap = OverlapParams.new() ampOverlap.FilterType = Enum.RaycastFilterType.Exclude

RunService.Heartbeat:Connect(function(dt)
    if _G.Settings.UseTools then equipTools() end

    if _G.Settings.HitboxExpander then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp and not modifiedHitboxes[hrp] then
                    modifiedHitboxes[hrp] = true
                    pcall(function()
                        hrp.Size = Vector3.new(_G.Settings.HitboxSize, _G.Settings.HitboxSize, _G.Settings.HitboxSize)
                        hrp.Transparency = 0.85 hrp.BrickColor = BrickColor.new("Royal blue") hrp.Material = Enum.Material.SmoothPlastic hrp.CanCollide = false
                        local box = hrp:FindFirstChild("HitboxVisual") or Instance.new("SelectionBox")
                        box.Name = "HitboxVisual" box.Adornee = hrp box.LineThickness = 0.04 box.Color3 = Color3.fromRGB(0, 132, 255) box.SurfaceTransparency = 1 box.Parent = hrp
                    end)
                elseif hrp and modifiedHitboxes[hrp] then hrp.Size = Vector3.new(_G.Settings.HitboxSize, _G.Settings.HitboxSize, _G.Settings.HitboxSize) end
            end
        end
    end

    if _G.Settings.HitAmplifier and LP.Character then
        local myRoot = LP.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            ampAccumulator = ampAccumulator + dt
            if ampAccumulator >= ampScanRate then
                ampAccumulator = 0 ampOverlap.FilterDescendantsInstances = { LP.Character }
                local parts = workspace:GetPartBoundsInBox(CFrame.new(myRoot.Position), Vector3.new(28, 28, 28), ampOverlap)
                for _, part in ipairs(parts) do
                    local model = part:FindFirstAncestorOfClass("Model")
                    if model and model ~= LP.Character then
                        local hum = model:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            for _, tool in ipairs(LP.Character:GetChildren()) do if tool:IsA("Tool") then pcall(tool.Activate, tool) pcall(tool.Activate, tool) end end
                            break
                        end
                    end
                end
            end
        end
    end

    if _G.Settings.ToolFollow and LP.Character then
        local targetChar = nil local closestDist = 35 local myRoot = LP.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local d = (p.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
                        if d < closestDist then closestDist = d targetChar = p.Character end
                    end
                end
            end
            if targetChar then
                local torso = cachedTargetTorsos[targetChar] or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso")
                if torso then
                    cachedTargetTorsos[targetChar] = torso
                    for _, part in ipairs(cachedToolParts) do
                        if part and part.Parent then
                            part.Position = torso.Position + Vector3.new(0, 0.6, 0.5)
                            firetouchinterest(part, torso, 0) firetouchinterest(part, torso, 1)
                        end
                    end
                end
            else
                for _, part in ipairs(cachedToolParts) do
                    if part and part.Parent then
                        local bv = part:FindFirstChildOfClass("BodyVelocity") or Instance.new("BodyVelocity", part)
                        bv.MaxForce = Vector3.new(4e5, 4e5, 4e5) bv.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end
    end

    if _G.Settings.Loopbring and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local myRoot = LP.Character.HumanoidRootPart
        for name in pairs(_G.BringTargets) do
            local p = Players:FindFirstChild(name)
            local tRoot = p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if tRoot then
                local targetPosition = myRoot.Position + (myRoot.CFrame.LookVector * 2)
                tRoot.CFrame = CFrame.new(targetPosition, myRoot.Position) * CFrame.Angles(0, math.rad(180), 0)
            end
        end
    end

    if _G.Settings.KillAura and #getgenv().configs.TargetList > 0 and LP.Character then
        local Ignorelist = OverlapParams.new() Ignorelist.FilterType = Enum.RaycastFilterType.Include
        local validTargets = {}
        for _, p in ipairs(getgenv().configs.TargetList) do
            if p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then table.insert(validTargets, p.Character) end
        end
        Ignorelist.FilterDescendantsInstances = validTargets

        for _, tool in ipairs(LP.Character:GetChildren()) do
            if tool:IsA("Tool") then
                for _, obj in ipairs(tool:GetDescendants()) do
                    if obj:IsA("TouchTransmitter") and obj.Parent:IsA("BasePart") then
                        local touch = obj.Parent
                        local parts = workspace:GetPartBoundsInBox(touch.CFrame, touch.Size + getgenv().configs.Size, Ignorelist)
                        for _, pPart in ipairs(parts) do
                            if tool:IsDescendantOf(workspace) then firetouchinterest(touch, pPart, 1) firetouchinterest(touch, pPart, 0) end
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
    while pulseAccum >= pulseInterval do pulseAccum = pulseAccum - pulseInterval activateTools() end
end)

WindUI:Notify({ Title = "DEATH WATCHERS LOADED", Content = "All high-frequency combat networks are now operational.", Duration = 5 })
