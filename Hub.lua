-- // DEATH WATCHERS | ULTIMATE PVP MATRIX ENGINE (V8.3 VISUAL CORE RESTORED)
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
    HitboxExpander = false, HitboxSize = 12, HitAmplifier = false, DoubleDamage = false,
    ToolFollow = false, ZeroCooldown = false, LoopbringDistance = 3,
    AntiPingSpike = false, AntiLagback = false
}

_G.BringTargets = {}

-- Global state management for custom Instant Aura logic
if getgenv().configs and getgenv().configs.connections then
    for _, c in ipairs(getgenv().configs.connections) do pcall(function() c:Disconnect() end) end
    table.clear(getgenv().configs)
end

getgenv().configs = {
    connections = {},
    Size = Vector3.new(30, 30, 30),
    TargetList = {}
}

local modifiedHitboxes, cachedToolParts = {}, {}
local Ignorelist = OverlapParams.new()
Ignorelist.FilterType = Enum.RaycastFilterType.Include

-- ⚡ DYNAMIC 0 COOLDOWN BREAKER HOOK ENGINE
local oWait, oTWait, oDelay, oSpawn
pcall(function()
    oWait = hookfunction(wait, function(...) if _G.Settings.ZeroCooldown then return RunService.PostSimulation:Wait() else return oWait(...) end end)
    oTWait = hookfunction(task.wait, function(...) if _G.Settings.ZeroCooldown then return RunService.PostSimulation:Wait() else return oTWait(...) end end)
    oDelay = hookfunction(delay, function(t, func) if _G.Settings.ZeroCooldown then return task.spawn(func) else return oDelay(t, func) end end)
    oSpawn = hookfunction(spawn, function(func) if _G.Settings.ZeroCooldown then return task.spawn(func) else return oSpawn(...) end end)
end)

-- ==========================================================
-- ⚡ FIXED QUANTUM TOOL GRABBER ENGINE (RESPAWN PERSISTENT)[source: 5]
-- ==========================================================
local Tycoons = workspace:WaitForChild("Tycoons")
local PAD_RANGE = 1000
local TOUCH_BURST = 8 

local allowedBases = {Stone=true, Magic=true, Storm=true, Robotic=true}
local excludedBases = {Insanity=true, Giant=true, Dark=true, Spike=true, Web=true, Strong=true}
local toolToBase = { ["Energy Sword"] = "Stone", ["Staff"] = "Magic", ["Axe"] = "Storm", ["Fist"] = "Robotic" }

local padsByBase = {}
local activeLoops = {}

local function registerPad(pad)
	local base = pad.Parent and pad.Parent.Parent
	if not base then return end
	if excludedBases[base.Name] or not allowedBases[base.Name] then return end
	padsByBase[base.Name] = padsByBase[base.Name] or {}
	table.insert(padsByBase[base.Name], pad)
end

for _, d in ipairs(Tycoons:GetDescendants()) do
	if d:IsA("TouchTransmitter") and d.Parent and d.Parent.Parent and d.Parent.Parent.Name:find("GearGiver1") then
		registerPad(d.Parent)
	end
end

Tycoons.DescendantAdded:Connect(function(d)
	if d:IsA("TouchTransmitter") and d.Parent and d.Parent.Parent and d.Parent.Parent.Name:find("GearGiver1") then
		registerPad(d.Parent)
	end
end)

local function hasSpecificTool(toolName)
	local function scan(container)
		if not container then return false end
		for _, t in ipairs(container:GetChildren()) do if t:IsA("Tool") and t.Name == toolName then return true end end
	end
	return scan(LP.Backpack) or scan(LP.Character)
end

local function getClosestPad(pads, root)
	local closest, dist
	for _, pad in ipairs(pads) do
		local d = (pad.Position - root.Position).Magnitude
		if d < PAD_RANGE and (not dist or d < dist) then dist = d closest = pad end
	end
	return closest
end

local function startToolLoop(toolName)
	local base = toolToBase[toolName]
	if not base then return end

	activeLoops[toolName] = true
	task.spawn(function()
		while activeLoops[toolName] and _G.Settings.ToolGrabber do
			if hasSpecificTool(toolName) then activeLoops[toolName] = nil break end
			local char = LP.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if not root then RunService.Heartbeat:Wait() continue end

			local pads = padsByBase[base]
			if pads then
				local pad = getClosestPad(pads, root)
				if pad then
					for i = 1, TOUCH_BURST do
						pcall(firetouchinterest, root, pad, 0)
						pcall(firetouchinterest, root, pad, 1)
					end
				end
			end
			task.wait()
		end
		activeLoops[toolName] = nil
	end)
end

local function triggerQuantumGrab()
	if not _G.Settings.ToolGrabber then return end
    table.clear(activeLoops) -- Vital Fix: Clears old loop configurations completely upon death invocation[source: 5]
	for toolName in pairs(toolToBase) do startToolLoop(toolName) end
end

-- ==========================================================
-- 🛡️ TOOL PHYSICS CACHING & HANDLING
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
-- ⚔️ COMBAT UTILITIES FOR INJECTED AURA IMPLEMENTATION[cite: 4]
-- ==========================================================
local function GetTouchInterest(tool)
	for _, obj in ipairs(tool:GetDescendants()) do
		if obj:IsA("TouchTransmitter") and obj.Parent:IsA("BasePart") then
			return obj.Parent
		end
	end
end

local function GetCharacters()
	local t = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character and p.Character:FindFirstChild("Humanoid") then
			if p.Character.Humanoid.Health > 0 then
				table.insert(t, p.Character)
			end
		end
	end
	return t
end

local function Attack(tool, touch, part)
	if tool:IsDescendantOf(workspace) then
		firetouchinterest(touch, part, 1)
		firetouchinterest(touch, part, 0)
	end
end

local function ApplyDamageInstant(tool, touch)
	local parts = workspace:GetPartBoundsInBox(
		touch.CFrame,
		touch.Size + getgenv().configs.Size,
		Ignorelist
	)

	for _, p in ipairs(parts) do
		local char = p:FindFirstAncestorWhichIsA("Model")
		if char then
			for _, target in ipairs(getgenv().configs.TargetList) do
				if target.Character == char then
					Attack(tool, touch, p)
					break
				end
			end
		end
	end
end

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
        if t:IsA("Tool") then pcall(t.Activate, t) end 
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
            if GuideEvent then GuideEvent:FireServer() else LP:LoadCharacter() end 
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
-- 🎨 WINDUI DASHBOARD TABS CONFIGURATION (FIXED DECOUPLING)
-- ==========================================================
local CombatTab  = Window:Tab({ Title = "PvP Mods", Icon = "swords" })
local GlitchTab  = Window:Tab({ Title = "Tycoon Glitch", Icon = "zap" })
local TargetTab  = Window:Tab({ Title = "Targeting", Icon = "crosshair" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })
local AdminTab   = Window:Tab({ Title = "Admin", Icon = "terminal" })
local ServerTab  = Window:Tab({ Title = "Server Info", Icon = "server" })
local InfoTab    = Window:Tab({ Title = "Identity", Icon = "user" })

-- --- 1. PvP COMBAT MODS ---
task.spawn(function()
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
        CombatTab:Toggle({ Title = "God-Tier 2X Instant Damage Loop", Value = false, Callback = function(v) _G.Settings.DoubleDamage = v end })
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
end)

-- --- 2. TYCOON GLITCH ENVIRONMENT ---
task.spawn(function()
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
end)

-- --- 3. TARGETING SYSTEMS (V8.3 EXTENDED WITH REWRITTEN INSTANT DAMAGE EXECUTION)[cite: 3, 4] ---
local activeButtonsMap = {}
local function populatePlayerTargetElements()
    pcall(function()
        for playerInstance, buttonRef in pairs(activeButtonsMap) do
            pcall(function() buttonRef:Destroy() end)
        end
        table.clear(activeButtonsMap)

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local isAuraTarget = table.find(getgenv().configs.TargetList, p) ~= nil
                local isLoopTarget = _G.BringTargets[p.Name] ~= nil
                
                local statusText = "[ Neutral Status ]"
                if isAuraTarget and isLoopTarget then statusText = "[ SPAWN KILLING + LOOPING ]"
                elseif isAuraTarget then statusText = "[ AURA MATRIX ACTIVE ]"
                elseif isLoopTarget then statusText = "[ LOOP VECTOR ACTIVE ]" end

                local targetButton = TargetTab:Button({
                    Title = p.DisplayName .. " (" .. statusText .. ")",
                    Desc = "Instantly injects @" .. p.Name .. " into high-velocity kill threads[cite: 4]",
                    Callback = function()
                        local auraIdx = table.find(getgenv().configs.TargetList, p)
                        if auraIdx then
                            table.remove(getgenv().configs.TargetList, auraIdx)
                            _G.BringTargets[p.Name] = nil
                        else
                            table.insert(getgenv().configs.TargetList, p)
                            _G.BringTargets[p.Name] = true
                        end
                        populatePlayerTargetElements()
                    end
                })
                activeButtonsMap[p] = targetButton
            end
        end
    end)
end

task.spawn(function()
    pcall(function()
        TargetTab:Section({ Title = "⚔️ Combat Routing Triggers" })
        TargetTab:Toggle({ Title = "Loopbring Target Vector", Value = false, Callback = function(v) _G.Settings.Loopbring = v end })
        TargetTab:Section({ Title = "🎯 Active Network Roster Selector" })
        TargetTab:Button({ Title = "🔄 Refresh Target Player List", Desc = "Forces manual layout rebuild and updates visibility tags", Callback = function() populatePlayerTargetElements() end })
        
        populatePlayerTargetElements()
        Players.PlayerAdded:Connect(populatePlayerTargetElements)
        Players.PlayerRemoving:Connect(populatePlayerTargetElements)
    end)
end)

-- --- 4. SETTINGS SECTION (WITH LAGGING OVERRIDE ENGINES)[cite: 4] ---
task.spawn(function()
    pcall(function()
        SettingsTab:Section({ Title = "🎨 UI Theme Customization" })
        
        SettingsTab:Colorpicker({
            Title = "Interface Core Accent Color",
            Default = Color3.fromRGB(0, 132, 255),
            Callback = function(color)
                pcall(function() Window:SetThemeColor(color) end)
            end
        })

        SettingsTab:Slider({
            Title = "Dashboard Panel Opacity",
            Min = 0,
            Max = 100,
            Value = 0,
            Callback = function(value)
                pcall(function()
                    local mainFrame = Window.Instance or Window.Frame
                    if mainFrame then mainFrame.BackgroundTransparency = (value / 100) end
                end)
            end
        })

        SettingsTab:Section({ Title = "📡 Network Stabilization Mechanics" })
        SettingsTab:Toggle({
            Title = "Anti-Ping Spike Matrix",
            Value = false,
            Callback = function(v)
                _G.Settings.AntiPingSpike = v
                if v then
                    settings().Network.IncomingReplicationLag = 0
                    pcall(function() settings().Network.DataSendRate = 60 end)
                end
            end
        })
        SettingsTab:Toggle({
            Title = "Velocity Anti-Lagback Engine[cite: 4]",
            Value = false,
            Callback = function(v)
                _G.Settings.AntiLagback = v
            end
        })

        SettingsTab:Section({ Title = "⚙️ Engine Performance Optimizations" })
        SettingsTab:Toggle({
            Title = "Working Anti-Lag Engine",
            Value = false,
            Callback = function(v)
                if v then
                    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("PostEffect") or obj:IsA("Explosion") or obj:IsA("Sparkles") then obj.Enabled = false
                        elseif obj:IsA("BasePart") and not obj:IsDescendantOf(LP.Character) then obj.Material = Enum.Material.SmoothPlastic end
                    end
                end
            end
        })

        SettingsTab:Slider({ Title = "Loopbring Distance Offset", Min = 0, Max = 20, Value = 3, Callback = function(v) _G.Settings.LoopbringDistance = v end })
    end)
end)

-- --- 5. DETAILED SERVER SECTION ---
local PlayerCountCard, PingCard, FpsCard, ServerTimeCard
task.spawn(function()
    pcall(function()
        ServerTab:Section({ Title = "👁️ Overwatch Intelligence" })
        ServerTab:Button({ Title = "Spy on Players (Spectator Mode)", Desc = "Deploys a bottom HUD to cycle cameras through active players.", Callback = function() startSpectating() end })

        ServerTab:Section({ Title = "🖥️ Live Environment Telemetry" })
        PlayerCountCard = ServerTab:Button({ Title = "Active Roster: Fetching..." })
        PingCard        = ServerTab:Button({ Title = "Network Latency: Fetching..." })
        FpsCard         = ServerTab:Button({ Title = "Core Frame Rate: Fetching..." })
        ServerTimeCard  = ServerTab:Button({ Title = "Server Runtime: Fetching..." })

        task.spawn(function()
            while task.wait(0.5) do
                pcall(function()
                    if PlayerCountCard then PlayerCountCard:SetTitle("Active Roster: " .. #Players:GetPlayers() .. " / " .. Players.MaxPlayers) end
                    if PingCard then PingCard:SetTitle("Network Latency: " .. math.round(Stats.Network.ServerToClientPing:GetValue() * 1000) .. " ms") end
                    if FpsCard then FpsCard:SetTitle("Core Frame Rate: " .. math.round(1 / RunService.Heartbeat:Wait()) .. " FPS") end
                    if ServerTimeCard then
                        local uptime = math.round(workspace.DistributedGameTime)
                        ServerTimeCard:SetTitle(string.format("Server Runtime: %02dh : %02dm : %02ds", math.floor(uptime / 3600), math.floor((uptime % 3600) / 60), uptime % 60))
                    end
                end)
            end
        end)
    end)
end)

-- --- 6. ADMIN UTILITIES ---
task.spawn(function()
    pcall(function()
        AdminTab:Section({ Title = "🛠️ Operational Overrides" })
        AdminTab:Button({ Title = "Load Nameless Admin Tools", Callback = function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Nameless-admin-v250-script-87765"))() end })
    end)
end)

-- --- 7. IDENTITY PROFILE ---
task.spawn(function()
    pcall(function()
        InfoTab:Section({ Title = "👤 Local Client Signatures" })
        InfoTab:Button({ Title = "Player Identity: " .. LP.Name, Callback = function() setclipboard(LP.Name) end })
    end)
end)

-- ==========================================================
-- 🚀 HIGH-VELOCITY RUNTIME IMPLEMENTATION LOOPS[cite: 4]
-- ==========================================================
local function runInstantSpawnSetup(char)
    if not char then return end
    pcall(function()
        char:WaitForChild("HumanoidRootPart", 5)
        hookCharacterHumanoid(char)
        updateToolCache()
        
        for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then fixToolPhysics(t) end end
        char.ChildAdded:Connect(function(c) if c:IsA("Tool") then task.wait() updateToolCache() fixToolPhysics(c) end end)
        
        if _G.Settings.ToolGrabber then
            triggerQuantumGrab()
        end
    end)
end

LP.CharacterAdded:Connect(function(char) 
    task.wait(0.1) -- Provide buffer for level setup geometry
    runInstantSpawnSetup(char) 
end)
if LP.Character then runInstantSpawnSetup(LP.Character) end

-- Heartbeat Loop: Tool Verification + Loopbring + Injected Damage & Hit Amp Handling[cite: 4, 7]
RunService.Heartbeat:Connect(function(dt)
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not root then return end

    if _G.Settings.UseTools then 
        equipTools()
        activateTools()
    end

    -- Anti-Lagback Interceptor Loop[cite: 4]
    if _G.Settings.AntiLagback and root then
        local vel = root.AssemblyLinearVelocity
        if vel.Magnitude > 120 then
            root.AssemblyLinearVelocity = vel.Unit * 30
        end
    end

    if _G.Settings.ToolGrabber then
        for toolName in pairs(toolToBase) do
            if not hasSpecificTool(toolName) then startToolLoop(toolName) end
        end
    end

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

    -- Ultra Smart Hit Amplifier Integration Hook[cite: 7]
    if _G.Settings.HitAmplifier then
        local overlapParams = OverlapParams.new()
        overlapParams.FilterType = Enum.RaycastFilterType.Blacklist
        overlapParams.FilterDescendantsInstances = { char }
        
        local parts = workspace:GetPartBoundsInBox(CFrame.new(root.Position), Vector3.new(28, 28, 28), overlapParams)
        for _, part in ipairs(parts) do
            local model = part:FindFirstAncestorOfClass("Model")
            if model then
                local hum = model:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and Players:GetPlayerFromCharacter(model) ~= LP then
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA("Tool") then
                            pcall(tool.Activate, tool)
                            pcall(tool.Activate, tool)
                        end
                    end
                    break
                end
            end
        end
    end

    -- Integrated Custom Script Damage Matrix Loop[cite: 4]
    if #getgenv().configs.TargetList > 0 then
        local chars = GetCharacters()
		Ignorelist.FilterDescendantsInstances = chars

		for _, tool in ipairs(char:GetChildren()) do
			if tool:IsA("Tool") then
				local touch = GetTouchInterest(tool)
				if touch then
					ApplyDamageInstant(tool, touch)
				end
			end
		end
    end
end)

-- RenderStepped Loop: High Frame-Rate Target Proximity Trigger + God-Tier 2X Damage Injection Layer[cite: 4]
RunService.RenderStepped:Connect(function()
    if #getgenv().configs.TargetList == 0 then return end
    local char = LP.Character
    if not char then return end

    local best
    for _, plr in ipairs(getgenv().configs.TargetList) do
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            local hum = plr.Character.Humanoid
            if hum.Health > 0 then
                if not best or hum.Health < best.Humanoid.Health then
                    best = { Humanoid = hum, Char = plr.Character }
                end
            end
        end
    end

    if not best then return end

    -- Determine how many simulation strike iterations to cycle per thread pass[cite: 4]
    local multiStrikeLoops = _G.Settings.DoubleDamage and 4 or 1

    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local touch = GetTouchInterest(tool)
            if touch then
                for _ = 1, multiStrikeLoops do
                    for _, part in ipairs(best.Char:GetChildren()) do
                        if part:IsA("BasePart") then
                            firetouchinterest(touch, part, 1)
                            firetouchinterest(touch, part, 0)
                        end
                    end
                end
            end
        end
    end
end)

WindUI:Notify({ Title = "DEATH WATCHERS CORE ONLINE", Content = "Multi-Matrix interface mounted smoothly.", Duration = 5 })
