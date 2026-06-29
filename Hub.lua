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

-- /* STREAMING_CHUNK:Building the Home Tab (Combat & Utilities) */
local HomeTab = Window:CreateTab("Home", 4483362458)
local CombatSection = HomeTab:CreateSection("Combat Modules")

HomeTab:CreateToggle({
	Name = "Hitbox Expander (Size 10)",
	CurrentValue = false,
	Flag = "HitboxToggle",
	Callback = function(state) _G.DW_Hitbox = state end
})

HomeTab:CreateToggle({
	Name = "Hit Amplifier (Max Speed)",
	CurrentValue = false,
	Flag = "HitAmpToggle",
	Callback = function(state) _G.DW_HitAmp = state end
})

local UtilitySection = HomeTab:CreateSection("Utility Modules")

HomeTab:CreateToggle({
	Name = "Auto Use All Tools",
	CurrentValue = false,
	Flag = "UseToolsToggle",
	Callback = function(state) _G.DW_UseTools = state end
})

HomeTab:CreateToggle({
	Name = "Quantum Tool Grabber",
	CurrentValue = false,
	Flag = "ToolGrabberToggle",
	Callback = function(state) _G.DW_ToolGrabber = state end
})

HomeTab:CreateToggle({
	Name = "Instant Respawn (Bypass Death)",
	CurrentValue = false,
	Flag = "InstantRespawnToggle",
	Callback = function(state) _G.DW_InstantRespawn = state end
})

HomeTab:CreateToggle({
	Name = "Anti-Spawn Kill (Escape Loopbring)",
	CurrentValue = false,
	Flag = "AntiSpawnKillToggle",
	Callback = function(state) _G.DW_AntiSpawnKill = state end
})

HomeTab:CreateButton({
	Name = "Enable No Cooldown",
	Callback = function()
		pcall(function()
			hookfunction(wait, function() return RunService.PostSimulation:Wait() end)
			hookfunction(task.wait, function() return RunService.PostSimulation:Wait() end)
			hookfunction(delay, function(_,func) task.spawn(func) end)
			hookfunction(spawn, function(func) task.spawn(func) end)
		end)
		Rayfield:Notify({Title = "Success", Content = "No Cooldown enabled globally.", Duration = 3})
	end
})

-- /* STREAMING_CHUNK:Building the Target & Combat Tab */
local TargetTab = Window:CreateTab("Targeting", 4483362458)
local TargetSection = TargetTab:CreateSection("Select a Target")

local function GetPlayerNames()
	local names = {}
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then table.insert(names, p.Name) end
	end
	return names
end

local TargetDropdown = TargetTab:CreateDropdown({
	Name = "Select Target Player",
	Options = GetPlayerNames(),
	CurrentOption = {"None"},
	MultipleOptions = false,
	Flag = "TargetDropdown",
	Callback = function(Option) _G.DW_TargetPlayer = Option[1] end,
})

TargetTab:CreateButton({
	Name = "Refresh Player List",
	Callback = function()
		TargetDropdown:Refresh(GetPlayerNames(), true)
		Rayfield:Notify({Title = "Refreshed", Content = "Player list updated.", Duration = 2})
	end
})

local TargetActionSection = TargetTab:CreateSection("Target Actions")

TargetTab:CreateToggle({
	Name = "Targeted Kill Aura",
	CurrentValue = false,
	Flag = "TargetKillAura",
	Callback = function(state) _G.DW_TargetAura = state end
})

TargetTab:CreateToggle({
	Name = "Targeted Loopbring",
	CurrentValue = false,
	Flag = "TargetLoopbring",
	Callback = function(state) _G.DW_Loopbring = state end
})

-- /* STREAMING_CHUNK:Building Admin Scripts & Info Tabs */
local AdminTab = Window:CreateTab("Admin", 4483362458)
local AdminSection = AdminTab:CreateSection("External Admin Scripts")

AdminTab:CreateButton({
	Name = "▶ Execute Nameless Admin",
	Callback = function()
		pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))() end)
		Rayfield:Notify({Title = "Executed", Content = "Nameless Admin loaded.", Duration = 3})
	end
})

AdminTab:CreateButton({
	Name = "📋 Copy Nameless Admin",
	Callback = function()
		if setclipboard then
			setclipboard("loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))()")
			Rayfield:Notify({Title = "Copied", Content = "Script copied to clipboard!", Duration = 3})
		end
	end
})

AdminTab:CreateButton({
	Name = "▶ Execute M7 Admin",
	Callback = function()
		pcall(function() loadstring(game:HttpGet("https://mois7.xyz/loader"))() end)
		Rayfield:Notify({Title = "Executed", Content = "M7 Admin loaded.", Duration = 3})
	end
})

AdminTab:CreateButton({
	Name = "📋 Copy M7 Admin",
	Callback = function()
		if setclipboard then
			setclipboard('loadstring(game:HttpGet("https://mois7.xyz/loader"))()')
			Rayfield:Notify({Title = "Copied", Content = "Script copied to clipboard!", Duration = 3})
		end
	end
})

local ServerTab = Window:CreateTab("Server", 0)
ServerTab:CreateLabel("Latency: " .. math.floor(LocalPlayer:GetNetworkPing() * 1000) .. "ms")
ServerTab:CreateButton({
	Name = "Copy JobId",
	Callback = function()
		if setclipboard then setclipboard(game.JobId) end
	end
})

local DisplayTab = Window:CreateTab("Identity", 0)
DisplayTab:CreateLabel("DisplayName: " .. (LocalPlayer.DisplayName or "Unknown"))
DisplayTab:CreateLabel("Username: " .. LocalPlayer.Name)

-- /* STREAMING_CHUNK:Core Module Logic Loops */
local GuideEvent = ReplicatedStorage:FindFirstChild("Guide")
local function BindRespawn(char)
	local hum = char:WaitForChild("Humanoid", 5)
	local hrp = char:WaitForChild("HumanoidRootPart", 5)
	if _G.DW_AntiSpawnKill and hrp then
		task.spawn(function()
			local startTime = tick()
			while tick() - startTime < 1.5 do
				if hrp and hrp.Parent then
					hrp.CFrame = hrp.CFrame * CFrame.new(math.random(-15, 15), 0, math.random(-15, 15))
					hrp.Velocity = Vector3.new(0, 0, 0)
				end
				RunService.Heartbeat:Wait()
			end
		end)
	end
	if hum then
		local triggered = false
		hum.HealthChanged:Connect(function(hp)
			if _G.DW_InstantRespawn and not triggered and hp <= 0 then
				triggered = true
				pcall(function() if GuideEvent then GuideEvent:FireServer() else LocalPlayer:LoadCharacter() end end)
			end
		end)
	end
end
LocalPlayer.CharacterAdded:Connect(BindRespawn)
if LocalPlayer.Character then BindRespawn(LocalPlayer.Character) end

RunService.Heartbeat:Connect(function()
	local myChar = LocalPlayer.Character
	if _G.DW_Hitbox then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
				p.Character.HumanoidRootPart.Transparency = 0.9
				p.Character.HumanoidRootPart.CanCollide = false
			end
		end
	end
	if _G.DW_UseTools and myChar then
		for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do if tool:IsA("Tool") then tool.Parent = myChar end end
		for _, tool in pairs(myChar:GetChildren()) do if tool:IsA("Tool") then pcall(tool.Activate, tool) end end
	end
	if _G.DW_Loopbring and _G.DW_TargetPlayer and myChar and myChar:FindFirstChild("HumanoidRootPart") then
		local target = Players:FindFirstChild(_G.DW_TargetPlayer)
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			target.Character.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3) * CFrame.Angles(0, math.rad(180), 0)
		end
	end
	if _G.DW_TargetAura or _G.DW_HitAmp then
		if not myChar then return end
		local currentTick = tick()
		if currentTick - _G.LastAuraTick < 0.06 then return end
		_G.LastAuraTick = currentTick
		local target = nil
		if _G.DW_TargetAura and _G.DW_TargetPlayer then
			local tPlayer = Players:FindFirstChild(_G.DW_TargetPlayer)
			if tPlayer and tPlayer.Character then target = tPlayer.Character:FindFirstChild("HumanoidRootPart") end
		end
		for _, tool in ipairs(myChar:GetChildren()) do
			if tool:IsA("Tool") then
				if _G.DW_HitAmp then pcall(tool.Activate, tool) end
				if _G.DW_TargetAura and target then
					local touchPart = tool:FindFirstChildWhichIsA("TouchTransmitter", true)
					if touchPart then
						pcall(firetouchinterest, touchPart.Parent, target, 0)
						pcall(firetouchinterest, touchPart.Parent, target, 1)
					end
				end
			end
		end
	end
end)

-- /* STREAMING_CHUNK:Quantum Tool Grabber Logic from "Tool Grabber.txt" */
local padsByBase = {}
local activeLoops = {}
local toolToBase = {["Energy Sword"]="Stone", ["Staff"]="Magic", ["Axe"]="Storm", ["Fist"]="Robotic"}
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

task.spawn(function()
	while true do
		if _G.DW_ToolGrabber then
			for toolName in pairs(toolToBase) do startToolLoop(toolName) end
		end
		task.wait(0.5)
	end
end)
