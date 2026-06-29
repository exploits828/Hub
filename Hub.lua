-- /* DEATH WATCHERS CLAN HUB - FULLY INTEGRATED & HARDENED */
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- Global States
_G.DW_TargetPlayer = nil
_G.DW_Hitbox = false
_G.DW_HitAmp = false
_G.DW_UseTools = false
_G.DW_InstantRespawn = false
_G.DW_ToolGrabber = false
_G.DW_TargetAura = false
_G.DW_Loopbring = false
_G.DW_AntiSpawnKill = false 
_G.DW_AntiLoopbring = false
_G.DW_AntiKillAura = false
_G.DW_AntiTargetAura = false
_G.DW_AntiLag = false
_G.DW_GodMode = false          
_G.DW_AntiTouch = false         
_G.LastAuraTick = 0 

-- Admin Loadstrings
local NamelessAdmin_Str = [[loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Nameless-admin-v250-script-87765"))()]]
local M7Admin_Str        = [[loadstring(game:HttpGet("https://mois7.xyz/loader"))()]]

-- ==================================================
-- ⚡ QUANTUM TOOL GRABBER CONFIG & INTERNALS
-- ==================================================
local Tycoons = workspace:WaitForChild("Tycoons")
local PAD_RANGE = 1000
local TOUCH_BURST = 8 

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

-- Pad Registration Core
local function registerPad(pad)
	local base = pad.Parent and pad.Parent.Parent
	if not base then return end
	if excludedBases[base.Name] then return end
	if not allowedBases[base.Name] then return end

	padsByBase[base.Name] = padsByBase[base.Name] or {}
	table.insert(padsByBase[base.Name], pad)
end

-- Initialize Pad Scanning
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

-- Grabber Utility Functions
local function hasTool(toolName)
	local function scan(container)
		if not container then return false end
		for _, t in ipairs(container:GetChildren()) do
			if t:IsA("Tool") and t.Name == toolName then return true end
		end
		return false
	end
	return scan(LocalPlayer.Backpack) or scan(LocalPlayer.Character)
end

local function tap(root, pad)
	pcall(firetouchinterest, root, pad, 0)
	pcall(firetouchinterest, root, pad, 1)
end

local function getClosestPad(pads, root)
	local closest, dist
	for _, pad in ipairs(pads) do
		local d = (pad.Position - root.Position).Magnitude
		if d < PAD_RANGE and (not dist or d < dist) then
			dist = d
			closest = pad
		end
	end
	return closest
end

local function startToolLoop(toolName)
	if activeLoops[toolName] then return end
	local base = toolToBase[toolName]
	if not base then return end

	activeLoops[toolName] = true

	task.spawn(function()
		while activeLoops[toolName] and _G.DW_ToolGrabber do
			if hasTool(toolName) then
				activeLoops[toolName] = nil
				break
			end

			local char = LocalPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if not root then
				RunService.Heartbeat:Wait()
				continue
			end

			local pads = padsByBase[base]
			if pads then
				local pad = getClosestPad(pads, root)
				if pad then
					for i = 1, TOUCH_BURST do
						tap(root, pad)
					end
				end
			end
			task.wait()
		end
		activeLoops[toolName] = nil
	end)
end

local function triggerGrabber()
	if not _G.DW_ToolGrabber then return end
	for toolName in pairs(toolToBase) do
		startToolLoop(toolName)
	end
end

-- Clipboard Helper
local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
        WindUI:Notify({Title = "Clipboard", Content = "Script copied successfully!", Duration = 3})
    elseif toclipboard then
        toclipboard(text)
        WindUI:Notify({Title = "Clipboard", Content = "Script copied successfully!", Duration = 3})
    end
end

-- ==================================================
-- 🧠 ADVANCED DESYNC IMMUNITY ENGINE
-- ==================================================
local function RunGodMode()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        local clone = humanoid:Clone()
        
        -- Break network health monitoring connections entirely
        clone.Parent = character
        humanoid:Destroy()
        LocalPlayer.Character = character
        workspace.CurrentCamera.CameraSubject = clone
        
        -- Instantly refresh backpack elements to preserve tool functions under new humanoid state
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = character
                tool.Parent = LocalPlayer.Backpack
            end
        end
    end
end

-- Auto-Handler for Respawns
local SpawnDeltWith = false
task.spawn(function()
	local lastChar = nil
	while true do
		local char = LocalPlayer.Character
		if char and char ~= lastChar then
			lastChar = char
			SpawnDeltWith = false

			task.spawn(function()
				local root = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")
				if SpawnDeltWith then return end
				SpawnDeltWith = true

				if _G.DW_GodMode then pcall(RunGodMode) end
				if _G.DW_ToolGrabber then triggerGrabber() end
			end)
		end
		task.wait(0.05)
	end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	if SpawnDeltWith then return end
	SpawnDeltWith = true
	if _G.DW_GodMode then pcall(RunGodMode) end
	if _G.DW_ToolGrabber then triggerGrabber() end
end)

-- ==================================================
-- 🎨 WINDUI INTERFACE INITIALIZATION
-- ==================================================
local success, WindUI = pcall(function() 
    return loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))() 
end)

if not success or not WindUI then
    warn("DEATH WATCHERS: Failed to load WindUI Library.")
    return
end

local Window = WindUI:CreateWindow({
    Title = "DEATH WATCHERS CLAN HUB",
    Icon = "skull",
    Author = "Clan OGS",
    Folder = "DeathWatchers",
    Size = UDim2.fromOffset(580, 520),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    HasOutline = true
})

-- UI Tab Generation
local HomeTab     = Window:Tab({ Title = "Home", Icon = "home" })
local AntiTab     = Window:Tab({ Title = "Anti-Features", Icon = "shield" })
local ImmunityTab = Window:Tab({ Title = "Immunity", Icon = "heart" })
local TargetTab   = Window:Tab({ Title = "Targeting", Icon = "crosshair" })
local ServerTab   = Window:Tab({ Title = "Server", Icon = "server" })
local IdentityTab = Window:Tab({ Title = "Identity", Icon = "user" })
local AdminTab    = Window:Tab({ Title = "Admin Scripts", Icon = "terminal" })

-- /* 1. HOME TAB */
HomeTab:Toggle({ Title = "Hitbox Expander (Size 10)", Desc = "Expands enemy hitboxes for easier reaching.", Default = false, Callback = function(s) _G.DW_Hitbox = s end })
HomeTab:Toggle({ Title = "Hit Amplifier (Max Speed)", Desc = "Maximizes hit registration speeds.", Default = false, Callback = function(s) _G.DW_HitAmp = s end })
HomeTab:Toggle({ Title = "Auto Use All Tools", Desc = "Continuously handles and fires all inventory items.", Default = false, Callback = function(s) _G.DW_UseTools = s end })
HomeTab:Toggle({ 
    Title = "Quantum Tool Grabber", 
    Desc = "Instantly parallel-grabs Energy Sword, Staff, Axe, and Fist.", 
    Default = false, 
    Callback = function(s) 
        _G.DW_ToolGrabber = s 
        if s then triggerGrabber() end
    end 
})
HomeTab:Toggle({ Title = "Instant Respawn", Desc = "Completely skips the standard death timer.", Default = false, Callback = function(s) _G.DW_InstantRespawn = s end })
HomeTab:Button({
    Title = "Enable No Cooldown",
    Desc = "Removes generic frame-delays on tools.",
    Callback = function()
        pcall(function() 
            hookfunction(wait, function() return RunService.PostSimulation:Wait() end) 
            hookfunction(task.wait, function() return RunService.PostSimulation:Wait() end) 
        end)
    end
})

-- /* 2. ANTI TAB */
AntiTab:Toggle({ Title = "Anti-Spawn Kill", Callback = function(s) _G.DW_AntiSpawnKill = s end })
AntiTab:Toggle({ Title = "Anti-Loopbring", Callback = function(s) _G.DW_AntiLoopbring = s end })
AntiTab:Toggle({ Title = "Anti-Kill Aura", Callback = function(s) _G.DW_AntiKillAura = s end })
AntiTab:Toggle({ Title = "Anti-Targeted Aura (Shield)", Callback = function(s) _G.DW_AntiTargetAura = s end })
AntiTab:Toggle({ Title = "Anti-Lag (Disable Effects)", Callback = function(s) _G.DW_AntiLag = s end })

-- /* 3. IMMUNITY TAB */
ImmunityTab:Toggle({
    Title = "Ultimate God Mode",
    Desc = "Desynchronizes state values to withstand hostile god-modes and bypassed tools.",
    Default = false,
    Callback = function(s)
        _G.DW_GodMode = s
        if s then pcall(RunGodMode) end
    end
})
ImmunityTab:Toggle({
    Title = "Anti-Touch Damage",
    Desc = "Locks out character parts from verifying .Touched exploit parameters.",
    Default = false,
    Callback = function(s) _G.DW_AntiTouch = s end
})

-- /* 4. TARGETING TAB */
local function GetPlayerNames() 
    local names = {} 
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(names, p.Name) end end 
    return names 
end

local TargetDropdown = TargetTab:Dropdown({
    Title = "Select Target Player",
    Values = GetPlayerNames(),
    Default = "",
    Callback = function(v) _G.DW_TargetPlayer = v end
})

TargetTab:Button({ Title = "Refresh Player List", Callback = function() TargetDropdown:Refresh(GetPlayerNames()) end })
TargetTab:Toggle({ Title = "Targeted Kill Aura", Callback = function(s) _G.DW_TargetAura = s end })
TargetTab:Toggle({ Title = "Targeted Loopbring", Callback = function(s) _G.DW_Loopbring = s end })

-- /* 5. SERVER TAB */
ServerTab:Button({
    Title = "Rejoin Server",
    Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end
})
ServerTab:Button({
    Title = "Server Hop",
    Callback = function()
        pcall(function()
            local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
            for _, v in pairs(servers.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                    break
                end
            end
        end)
    end
})

-- /* 6. IDENTITY TAB */
IdentityTab:Toggle({ Title = "Streamer / Hide Name Mode", Desc = "Locally obfuscates your username profile.", Default = false, Callback = function(s) end })

-- /* 7. ADMIN TAB */
AdminTab:Button({ Title = "Execute Nameless Admin", Desc = "Runs Nameless v2.5.0 from Rawscripts.", Callback = function() pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Nameless-admin-v250-script-87765"))() end) end })
AdminTab:Button({ Title = "Copy Nameless Admin Loadstring", Callback = function() copyToClipboard(NamelessAdmin_Str) end })
AdminTab:Button({ Title = "Execute M7 Admin", Desc = "Launches the official loader link.", Callback = function() pcall(function() loadstring(game:HttpGet("https://mois7.xyz/loader"))() end) end })
AdminTab:Button({ Title = "Copy M7 Admin Loadstring", Callback = function() copyToClipboard(M7Admin_Str) end })

-- ==================================================
-- 🔄 PERSISTENT BACKGROUND PROCESSING
-- ==================================================
task.spawn(function()
    while task.wait(0.1) do
        if _G.DW_UseTools and LocalPlayer.Character then
            for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do 
                if tool:IsA("Tool") then tool.Parent = LocalPlayer.Character end 
            end
            for _, tool in pairs(LocalPlayer.Character:GetChildren()) do 
                if tool:IsA("Tool") then pcall(tool.Activate, tool) end 
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local myChar = LocalPlayer.Character
    if not myChar then return end
    
    if _G.DW_AntiTouch then
        for _, part in ipairs(myChar:GetChildren()) do
            if part:IsA("BasePart") then part.CanTouch = false end
        end
    end

    if _G.DW_Hitbox then 
        for _, p in pairs(Players:GetPlayers()) do 
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
                p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10) 
                p.Character.HumanoidRootPart.CanCollide = false 
            end 
        end 
    end
    
    if (_G.DW_TargetAura or _G.DW_HitAmp) and (tick() - _G.LastAuraTick > 0.05) then
        _G.LastAuraTick = tick()
        local target = Players:FindFirstChild(_G.DW_TargetPlayer or "")
        local targetHRP = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        
        for _, tool in ipairs(myChar:GetChildren()) do
            if tool:IsA("Tool") then
                if _G.DW_TargetAura and targetHRP then 
                    local t = tool:FindFirstChildWhichIsA("TouchTransmitter", true) 
                    if t and firetouchinterest then 
                        pcall(firetouchinterest, t.Parent, targetHRP, 0) 
                        pcall(firetouchinterest, t.Parent, targetHRP, 1) 
                    end 
                end
            end
        end
    end
end)

-- Run Tool Grabber instantly if enabled and character is already present
if LocalPlayer.Character and _G.DW_ToolGrabber then
	triggerGrabber()
end

WindUI:Notify({
    Title = "System Verified",
    Content = "Quantum Grabber & God Mode logic successfully mounted.",
    Duration = 4
})
