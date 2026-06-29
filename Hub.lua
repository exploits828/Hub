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
	DisableRayfieldPrompts = true, -- 🛑 Set to true to stop the annoying looping popups
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

-- 🛡️ Anti-Spawn Kill Toggle
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
	Name = "▶ Execute M7 Admin",
	Callback = function()
		pcall(function() loadstring(game:HttpGet("https://mois7.xyz/loader"))() end)
		Rayfield:Notify({Title = "Executed", Content = "M7 Admin loaded.", Duration = 3})
	end
})

-- /* STREAMING_CHUNK:Core Module Logic Loops */

-- 1. True Instant Respawn & Anti-Spawn Kill Handler
local GuideEvent = ReplicatedStorage:FindFirstChild("Guide")
local function BindRespawn(char)
	local hum = char:WaitForChild("Humanoid", 5)
	local hrp = char:WaitForChild("HumanoidRootPart", 5)
	
	-- Anti-Spawn Kill: Safe displacement upon spawning to break enemy script indexing
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
				pcall(function()
					if GuideEvent then GuideEvent:FireServer() else LocalPlayer:LoadCharacter() end
				end)
			end
		end)
	end
end
LocalPlayer.CharacterAdded:Connect(BindRespawn)
if LocalPlayer.Character then BindRespawn(LocalPlayer.Character) end

-- 2. Master Runtime Loop
RunService.Heartbeat:Connect(function()
	local myChar = LocalPlayer.Character
	
	-- Hitbox Expander
	if _G.DW_Hitbox then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
				p.Character.HumanoidRootPart.Transparency = 0.9
				p.Character.HumanoidRootPart.CanCollide = false
			end
		end
	end

	-- Auto Use Tools
	if _G.DW_UseTools and myChar then
		for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
			if tool:IsA("Tool") then tool.Parent = myChar end
		end
		for _, tool in pairs(myChar:GetChildren()) do
			if tool:IsA("Tool") then pcall(tool.Activate, tool) end
		end
	end

	-- Targeted Loopbring
	if _G.DW_Loopbring and _G.DW_TargetPlayer and myChar and myChar:FindFirstChild("HumanoidRootPart") then
		local target = Players:FindFirstChild(_G.DW_TargetPlayer)
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local tHRP = target.Character.HumanoidRootPart
			local myHRP = myChar.HumanoidRootPart
			tHRP.CFrame = myHRP.CFrame * CFrame.new(0, 0, -3) * CFrame.Angles(0, math.rad(180), 0)
		end
	end

	-- Targeted Kill Aura & Hit Amplifier (Stabilized)
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

-- 3. Quantum Tool Grabber Loop
task.spawn(function()
	local allowedBases = {Stone=true, Magic=true, Storm=true, Robotic=true}
	local toolToBase = {["Energy Sword"]="Stone", ["Staff"]="Magic", ["Axe"]="Storm", ["Fist"]="Robotic"}
	local PAD_RANGE = 1000
	
	local function hasTool(toolName)
		local function scan(container)
			if not container then return false end
			for _,t in ipairs(container:GetChildren()) do
				if t:IsA("Tool") and t.Name == toolName then return true end
			end
		end
		return scan(LocalPlayer.Backpack) or scan(LocalPlayer.Character)
	end

	while task.wait(0.2) do
		if _G.DW_ToolGrabber and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = LocalPlayer.Character.HumanoidRootPart
			local tycoons = workspace:FindFirstChild("Tycoons")
			
			if tycoons then
				local pads = {}
				for _, d in ipairs(tycoons:GetDescendants()) do
					if d:IsA("TouchTransmitter") and d.Parent and d.Parent.Parent and d.Parent.Parent.Name:find("GearGiver1") then
						local baseName = d.Parent.Parent.Parent.Name
						if allowedBases[baseName] then
							table.insert(pads, {pad = d.Parent, dist = (d.Parent.Position - hrp.Position).Magnitude})
						end
					end
				end
				
				table.sort(pads, function(a,b) return a.dist < b.dist end)
				
				for toolName, baseName in pairs(toolToBase) do
					if not hasTool(toolName) then
						for _, pData in ipairs(pads) do
							if pData.pad.Parent.Parent.Parent.Name == baseName and pData.dist < PAD_RANGE then
								for i = 1, 4 do 
									pcall(firetouchinterest, hrp, pData.pad, 0)
									pcall(firetouchinterest, hrp, pData.pad, 1)
								end
								break
							end
						end
					end
				end
			end
			
			for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
				if toolToBase[tool.Name] then tool.Parent = LocalPlayer.Character end
			end
		end
	end
end)
