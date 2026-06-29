-- /* STREAMING_CHUNK:Initializing Services & Rayfield */
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Global States for Toggles
_G.DW_TargetPlayer = nil
_G.DW_Hitbox = false
_G.DW_HitAmp = false
_G.DW_UseTools = false
_G.DW_InstantRespawn = false
_G.DW_ToolGrabber = false
_G.DW_TargetAura = false
_G.DW_Loopbring = false
_G.DW_AntiSpawnKill = false 
_G.LastAuraTick = 0 

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
	Name = "DEATH WATCHERS CLAN HUB",
	LoadingTitle = "Death Watchers Interface",
	LoadingSubtitle = "Powered by Rayfield",
	Theme = "Default",
	DisableRayfieldPrompts = true,
	KeySystem = true,
	KeySettings = {
		Title = "Access Required",
		Subtitle = "Death Watchers Key System",
		Note = "Key: pvpOGS",
		FileName = "DW_Clan_Key",
		SaveKey = true,
		GrabKeyFromSite = false,
		Key = {"pvpOGS"}
	}
})

-- /* STREAMING_CHUNK:Building the Home Tab */
local HomeTab = Window:CreateTab("Home", 4483362458)
local CombatSection = HomeTab:CreateSection("Combat Modules")

HomeTab:CreateToggle({Name = "Hitbox Expander (Size 10)", CurrentValue = false, Callback = function(state) _G.DW_Hitbox = state end})
HomeTab:CreateToggle({Name = "Hit Amplifier (Max Speed)", CurrentValue = false, Callback = function(state) _G.DW_HitAmp = state end})

local UtilitySection = HomeTab:CreateSection("Utility Modules")
HomeTab:CreateToggle({Name = "Auto Use All Tools", CurrentValue = false, Callback = function(state) _G.DW_UseTools = state end})
HomeTab:CreateToggle({Name = "Quantum Tool Grabber", CurrentValue = false, Callback = function(state) _G.DW_ToolGrabber = state end})
HomeTab:CreateToggle({Name = "Instant Respawn (Bypass Death)", CurrentValue = false, Callback = function(state) _G.DW_InstantRespawn = state end})
HomeTab:CreateToggle({Name = "Anti-Spawn Kill (Escape Loopbring)", CurrentValue = false, Callback = function(state) _G.DW_AntiSpawnKill = state end})

HomeTab:CreateButton({
	Name = "Enable No Cooldown",
	Callback = function()
		pcall(function()
			hookfunction(wait, function() return RunService.PostSimulation:Wait() end)
			hookfunction(task.wait, function() return RunService.PostSimulation:Wait() end)
			hookfunction(delay, function(_,func) task.spawn(func) end)
			hookfunction(spawn, function(func) task.spawn(func) end)
		end)
	end
})

-- /* STREAMING_CHUNK:Building the Target Tab */
local TargetTab = Window:CreateTab("Targeting", 4483362458)
local TargetDropdown = TargetTab:CreateDropdown({
	Name = "Select Target Player",
	Options = {},
	Callback = function(Option) _G.DW_TargetPlayer = Option[1] end,
})

TargetTab:CreateButton({Name = "Refresh Player List", Callback = function() TargetDropdown:Refresh(GetPlayerNames(), true) end})
TargetTab:CreateToggle({Name = "Targeted Kill Aura", CurrentValue = false, Callback = function(state) _G.DW_TargetAura = state end})
TargetTab:CreateToggle({Name = "Targeted Loopbring", CurrentValue = false, Callback = function(state) _G.DW_Loopbring = state end})

-- /* STREAMING_CHUNK:Admin, Server, and Identity Tabs */
local AdminTab = Window:CreateTab("Admin", 4483362458)
AdminTab:CreateButton({Name = "▶ Execute Nameless Admin", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))() end})
AdminTab:CreateButton({Name = "▶ Execute M7 Admin", Callback = function() loadstring(game:HttpGet("https://mois7.xyz/loader"))() end})

local ServerTab = Window:CreateTab("Server", 0)
ServerTab:CreateLabel("Latency: " .. math.floor(LocalPlayer:GetNetworkPing() * 1000) .. "ms")
ServerTab:CreateButton({Name = "Copy JobId", Callback = function() if setclipboard then setclipboard(game.JobId) end end})

-- /* STREAMING_CHUNK:Core Module Logic Loops */
local padsByBase = {}
local activeLoops = {}
local toolToBase = {["Energy Sword"] = "Stone", ["Staff"] = "Magic", ["Axe"] = "Storm", ["Fist"] = "Robotic"}
local allowedBases = {Stone=true, Magic=true, Storm=true, Robotic=true}

local function register(pad)
	local base = pad.Parent and pad.Parent.Parent
	if base and allowedBases[base.Name] then
		padsByBase[base.Name] = padsByBase[base.Name] or {}
		table.insert(padsByBase[base.Name], pad)
	end
end

for _, d in ipairs(workspace:WaitForChild("Tycoons"):GetDescendants()) do
	if d:IsA("TouchTransmitter") and d.Parent and d.Parent.Parent and d.Parent.Parent.Name:find("GearGiver1") then register(d.Parent) end
end

local function hasTool(toolName)
	return (LocalPlayer.Backpack:FindFirstChild(toolName) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(toolName))) ~= nil
end

local function startToolLoop(toolName)
	if activeLoops[toolName] then return end
	activeLoops[toolName] = true
	task.spawn(function()
		while activeLoops[toolName] and _G.DW_ToolGrabber do
			if hasTool(toolName) then activeLoops[toolName] = nil break end
			local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			local pads = padsByBase[toolToBase[toolName]]
			if root and pads then
				for _, pad in ipairs(pads) do
					if (pad.Position - root.Position).Magnitude < 1000 then
						for i = 1, 8 do pcall(firetouchinterest, root, pad, 0) pcall(firetouchinterest, root, pad, 1) end
					end
				end
			end
			task.wait()
		end
	end)
end

RunService.Heartbeat:Connect(function()
	-- Tool Grabber Trigger
	if _G.DW_ToolGrabber then
		for toolName in pairs(toolToBase) do startToolLoop(toolName) end
	end
	
	-- Hitbox / Aura / Loopbring / UseTools logic (Insert your original code here)
end)
