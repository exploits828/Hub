-- // DEATH WATCHERS | ULTIMATE PVP MATRIX ENGINE (WINDUI PRODUCTION V8.3 MODDED)
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
    ToolFollow = false, ZeroCooldown = false, LoopbringDistance = 3,
    AntiLag = false, AntiPing = false
}

_G.BringTargets = {}
getgenv().configs = { connections = {}, Size = Vector3.new(30, 30, 30) }
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

-- Isolated explicitly to weapons from Screenshot_20260630-013938.jpg through Screenshot_20260630-014213.jpg
local toolToBase = {
    ["Axe"] = "Storm",          -- Storm Tycoon 1st Floor (Screenshot_20260630-013938.jpg / Screenshot_20260630-014009.jpg)
    ["Fists"] = "Robotic",      -- Robotic Tycoon 1st Floor (Screenshot_20260630-014100.jpg / Screenshot_20260630-014109.jpg)
    ["Energy Sword"] = "Stone", -- Stone Tycoon 1st Floor (Screenshot_20260630-014124.jpg / Screenshot_20260630-014132.jpg)
    ["Staff"] = "Magic"         -- Magic Tycoon 1st Floor (Screenshot_20260630-014206.jpg / Screenshot_20260630-014213.jpg)
}

local padsByBase, activeLoops = {}, {}

local function registerPad(pad)
    local base = pad.Parent and pad.Parent.Parent
    if not base or not toolToBase[pad.Parent.Name] or base.Name ~= toolToBase[pad.Parent.Name] then return end
    padsByBase[base.Name] = padsByBase[base.Name] or {}
    table.insert(padsByBase[base.Name], pad)
end

local function scanPads()
    table.clear(padsByBase)
    if Tycoons then
        for _, d in ipairs(Tycoons:GetDescendants()) do
            if d:IsA("TouchTransmitter") and d.Parent then
                local weaponName = d.Parent.Name
                -- Verify weapon matches name registry and target Tycoon structural parent strictly
                if toolToBase[weaponName] and d.Parent.Parent and d.Parent.Parent.Parent and d.Parent.Parent.Parent.Name == toolToBase[weaponName] then
                    padsByBase[toolToBase[weaponName]] = padsByBase[toolToBase[weaponName]] or {}
                    table.insert(padsByBase[toolToBase[weaponName]], d)
                end
            end
        end
    end
end
scanPads()

local function hasSpecificTool(toolName)
    local function scan(container)
        if not container then return false end
        for _, t in ipairs(container:GetChildren()) do if t:IsA("Tool") and t.Name == toolName then return true end end
        return false
    end
    return scan(LP.Backpack) or scan(LP.Character)
end

local function runParallelGrabLoop(toolName)
    if activeLoops[toolName] then return end
    local base = toolToBase[toolName]
    if not base then return end

    activeLoops[toolName] = true
    task.spawn(function()
        while activeLoops[toolName] and _G.Settings.ToolGrabber do
            if not hasSpecificTool(toolName) then
                local char = LP.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root and padsByBase[base] then
                    for _, pad in ipairs(padsByBase[base]) do
                        if pad.Parent and pad.Parent:IsA("BasePart") then
                            for i = 1, 3 do 
                                firetouchinterest(root, pad.Parent, 0) 
                                firetouchinterest(root, pad.Parent, 1) 
                            end
                        end
                    end
                end
            end
            task.wait(0.25)
        end
        activeLoops[toolName] = nil
    end)
end

local function triggerQuantumGrab()
    if not _G.Settings.ToolGrabber then return end
    scanPads()
    for toolName in pairs(toolToBase) do runParallelGrabLoop(toolName) end
end

if Tycoons then
    Tycoons.DescendantAdded:Connect(function(d)
        if _G.Settings.ToolGrabber and d:IsA("TouchTransmitter") and d.Parent then
            task.wait(0.1)
            scanPads()
        end
    end)
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
    for _, tool in ipairs(LP.Backpack:GetChildren()) do
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
-- ⚔️ INSTANT PERFORMANCE ATTACK ENGINE (DELAY REMOVED)
-- ==========================================================
local function equipTools()
    local char, bp = LP.Character, LP.Backpack
    if not char or not bp then return end
    for _, t in ipairs(bp:GetChildren()) do 
        if t:IsA("Tool") and t.Parent ~= char then 
            t.Parent = char 
            fixToolPhysics(t)
        end 
    end
end

local function activateTools()
    local char = LP.Character if not char then return end
    for _, t in ipairs(char:GetChildren()) do 
        if t:IsA("Tool") then 
            pcall(t.Activate, t) 
        end 
    end
end

-- ==========================================================
-- 💀 QUANTUM PRE-DEATH RESPAWN ENGINE
-- ==========================================================
local GuideEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Guide")
local respawnFired = false

local function executeInstantRespawn()
    if respawnFired or not _G.Settings.Respawn then return end
    respawnFired = true
    local function fire() 
        pcall(function() 
            if GuideEvent then 
                GuideEvent:FireServer() 
            else 
                LP:LoadCharacter() 
            end 
        end) 
    end
    fire() task.delay(0.01, fire) task.delay(0.1, function() respawnFired = false end)
end

local function hookCharacterHumanoid(char)
    local hum = char:WaitForChild("Humanoid", 5) if not hum then return end
    hum.HealthChanged:Connect(function(hp) if _G.Settings.Respawn and hp <= 1 then executeInstantRespawn() end end)
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
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })
local AdminTab   = Window:Tab({ Title = "Admin", Icon = "terminal" })
local ServerTab  = Window:Tab({ Title = "Server Info", Icon = "server" })
local InfoTab    = Window:Tab({ Title = "Identity", Icon = "user" })

-- --- 1. PvP COMBAT MODS ---
pcall(function()
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
end)

-- --- 2. TYCOON GLITCH ENVIRONMENT ---
pcall(function()
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
end)

-- --- 3. TARGETING SYSTEMS INTERFACE ---
local currentDropdown = nil
local function updateLoopbringDropdown()
    if not currentDropdown then return end
    local playerNames = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then table.insert(playerNames, p.Name) end
    end
    currentDropdown:SetOptions(playerNames)
end

pcall(function()
    TargetTab:Section({ Title = "⚔️ Global Combat Triggers" })
    TargetTab:Toggle({ Title = "Normal Kill Aura (30ft Radius)", Value = false, Callback = function(v) _G.Settings.KillAura = v end })
    
    TargetTab:Section({ Title = "🌀 Teleportation Matrix" })
    TargetTab:Toggle({ Title = "Loopbring Target Vector", Value = false, Callback = function(v) _G.Settings.Loopbring = v end })
    
    local initialNames = {}
    for _, p in ipairs(Players:GetPlayers()) do if p ~= LP then table.insert(initialNames, p.Name) end end
    
    currentDropdown = TargetTab:Dropdown({
        Title = "Select Loopbring Target",
        Desc = "Instantly locks the player vector to loop teleport",
        Options = initialNames,
        Callback = function(selectedName)
            table.clear(_G.BringTargets)
            if selectedName and selectedName ~= "" then
                _G.BringTargets[selectedName] = true
                WindUI:Notify({ Title = "Loopbring Target Locked", Content = "Target assigned: " .. selectedName, Duration = 2 })
            end
        end
    })

    Players.PlayerAdded:Connect(updateLoopbringDropdown)
    Players.PlayerRemoving:Connect(updateLoopbringDropdown)
end)

-- --- 4. SETTINGS SECTION ---
pcall(function()
    SettingsTab:Section({ Title = "⚙️ Engine Performance Optimizations" })
    
    SettingsTab:Toggle({
        Title = "Working Anti-Lag Engine",
        Value = false,
        Callback = function(v)
            _G.Settings.AntiLag = v
            if v then
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("PostEffect") or obj:IsA("Explosion") or obj:IsA("Sparkles") then
                        obj.Enabled = false
                    elseif obj:IsA("BasePart") and not obj:IsDescendantOf(LP.Character) then
                        obj.Material = Enum.Material.SmoothPlastic
                    end
                end
            end
        end
    })
    
    SettingsTab:Toggle({
        Title = "Anti-Ping Spike Network Lock",
        Value = false,
        Callback = function(v)
            _G.Settings.AntiPing = v
            if v then
                if workspace:FindFirstChild("Terrain") then workspace.Terrain:Clear() end
                pcall(function()
                    game:GetService("Lighting").GlobalShadows = false
                    game:GetService("Lighting").FogEnd = 9e9
                end)
            end
        end
    })

    SettingsTab:Section({ Title = "📏 Vector Distance Configs" })
    SettingsTab:Slider({
        Title = "Loopbring Target Offset Distance",
        Min = 0,
        Max = 20,
        Value = 3,
        Callback = function(v) _G.Settings.LoopbringDistance = v end
    })
end)

-- --- 5. DETAILED SERVER SECTION ---
local PlayerCountCard, PingCard, FpsCard, ServerTimeCard
pcall(function()
    ServerTab:Section({ Title = "👁️ Overwatch Intelligence" })
    ServerTab:Button({
        Title = "Spy on Players (Spectator Mode)",
        Desc = "Deploys a bottom HUD to cycle cameras through active players.",
        Callback = function() startSpectating() end
    })

    ServerTab:Section({ Title = "🖥️ Live Environment Telemetry" })
    PlayerCountCard = ServerTab:Button({ Title = "Active Roster: Fetching...", Desc = "Total players currently connected" })
    PingCard        = ServerTab:Button({ Title = "Network Latency: Fetching...", Desc = "Real-time client response ping" })
    FpsCard         = ServerTab:Button({ Title = "Core Frame Rate: Fetching...", Desc = "Render performance speed" })
    ServerTimeCard  = ServerTab:Button({ Title = "Server Runtime: Fetching...", Desc = "Elapsed time since instance startup" })

    ServerTab:Section({ Title = "Bases & Instances" })
    ServerTab:Button({ Title = "Copy Server Job Identification ID", Desc = "Click to save game.JobId to local clipboard", Callback = function() setclipboard(game.JobId) end })

    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if PlayerCountCard then PlayerCountCard:SetTitle("Active Roster: " .. #Players:GetPlayers() .. " / " .. Players.MaxPlayers) end
                if PingCard then
                    local ping = math.round(Stats.Network.ServerToClientPing:GetValue() * 1000)
                    PingCard:SetTitle("Network Latency: " .. ping .. " ms")
                end
                if FpsCard then
                    local fps = math.round(1 / RunService.Heartbeat:Wait())
                    FpsCard:SetTitle("Core Frame Rate: " .. fps .. " FPS")
                end
                if ServerTimeCard then
                    local uptime = math.round(workspace.DistributedGameTime)
                    local hours = math.floor(uptime / 3600)
                    local minutes = math.floor((uptime % 3600) / 60)
                    local seconds = uptime % 60
                    ServerTimeCard:SetTitle(string.format("Server Runtime: %02dh : %02dm : %02ds", hours, minutes, seconds))
                end
            end)
        end
    end)
end)

-- --- 6. ADMIN UTILITIES ---
pcall(function()
    AdminTab:Section({ Title = "🛠️ Operational Overrides" })
    AdminTab:Button({ Title = "Load Nameless Admin Tools", Desc = "Executes the universal high-privilege administrative script environment", Callback = function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Nameless-admin-v250-script-87765"))() end })
end)

-- --- 7. IDENTITY PROFILE ---
pcall(function()
    InfoTab:Section({ Title = "👤 Local Client Signatures" })
    InfoTab:Button({ Title = "Player Identity: " .. LP.Name, Desc = "Click to copy username to clipboard", Callback = function() setclipboard(LP.Name) end })
    InfoTab:Button({ Title = "Network Account ID: " .. LP.UserId, Desc = "Click to copy user identification number", Callback = function() setclipboard(tostring(LP.UserId)) end })
end)

-- ==========================================================
-- 🚀 HIGH-VELOCITY CORE RUNTIME SYNCHRONIZATION
-- ==========================================================
local function runInstantSpawnSetup(char)
    if not char then return end
    pcall(function()
        char:WaitForChild("HumanoidRootPart", 5)
        hookCharacterHumanoid(char)
        updateToolCache()
        
        for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then fixToolPhysics(t) end end
        char.ChildAdded:Connect(function(c)
            if c:IsA("Tool") then task.wait() updateToolCache() fixToolPhysics(c) end
        end)
        
        if _G.Settings.ToolGrabber then triggerQuantumGrab() end
    end)
end

LP.CharacterAdded:Connect(runInstantSpawnSetup)
if LP.Character then runInstantSpawnSetup(LP.Character) end

-- Persistent Character State Enforcement Loop
RunService.Heartbeat:Connect(function(dt)
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not root then return end

    -- Raw zero-delay weapon activation engine to beat spawn killers instantly
    if _G.Settings.UseTools then 
        equipTools()
        activateTools()
    end

    -- Persistent verification scanning loop for missing weapons
    if _G.Settings.ToolGrabber then
        for toolName in pairs(toolToBase) do
            if not hasSpecificTool(toolName) then runParallelGrabLoop(toolName) end
        end
    end

    -- Hitbox Expander
    if _G.Settings.HitboxExpander then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function()
                        hrp.Size = Vector3.new(_G.Settings.HitboxSize, _G.Settings.HitboxSize, _G.Settings.HitboxSize)
                        hrp.Transparency = 0.85
                        hrp.CanCollide = false
                        if not hrp:FindFirstChild("HitboxVisual") then
                            local box = Instance.new("SelectionBox")
                            box.Name = "HitboxVisual" box.Adornee = hrp box.LineThickness = 0.04 box.Color3 = Color3.fromRGB(0, 132, 255) box.Parent = hrp
                        end
                    end)
                end
            end
        end
    end

    -- Loopbring Target Vector Execution Engine
    if _G.Settings.Loopbring then
        for targetName, enabled in pairs(_G.BringTargets) do
            if enabled then
                local targetPlayer = Players:FindFirstChild(targetName)
                if targetPlayer and targetPlayer.Character then
                    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        targetRoot.CFrame = root.CFrame * CFrame.new(0, 0, -_G.Settings.LoopbringDistance)
                    end
                end
            end
        end
    end

    -- Normal Radius-Based Kill Aura Matrix (Auto targets everyone inside a 30ft radius)
    if _G.Settings.KillAura then
        pcall(function()
            local validTargets = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                    local pRoot = p.Character:FindFirstChild("HumanoidRootPart")
                    if pRoot and (pRoot.Position - root.Position).Magnitude <= 30 then
                        table.insert(validTargets, p.Character)
                    end
                end
            end

            if #validTargets > 0 then
                local Ignorelist = OverlapParams.new() 
                Ignorelist.FilterType = Enum.RaycastFilterType.Include 
                Ignorelist.FilterDescendantsInstances = validTargets

                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        for _, obj in ipairs(tool:GetDescendants()) do
                            if obj:IsA("TouchTransmitter") and obj.Parent:IsA("BasePart") then
                                local touch = obj.Parent
                                local parts = workspace:GetPartBoundsInBox(touch.CFrame, touch.Size + getgenv().configs.Size, Ignorelist)
                                for _, pPart in ipairs(parts) do
                                    if tool:IsDescendantOf(workspace) then 
                                        firetouchinterest(touch, pPart, 1) 
                                        firetouchinterest(touch, pPart, 0) 
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

WindUI:Notify({ Title = "DEATH WATCHERS V8.3 MODDED", Content = "Asynchronous matrix configurations completely finalized.", Duration = 5 })
