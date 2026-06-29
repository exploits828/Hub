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
HomeTab:CreateToggle({
	Name = "Hitbox Expander (Size 10)",
	CurrentValue = false,
	Callback = function(state) _G.DW_Hitbox = state end
})

HomeTab:CreateToggle({
	Name = "Hit Amplifier (Max Speed)",
	CurrentValue = false,
	Callback = function(state) _G.DW_HitAmp = state end
})

HomeTab:CreateToggle({
	Name = "Auto Use All Tools",
	CurrentValue = false,
	Callback = function(state) _G.DW_UseTools = state end
})

HomeTab:CreateToggle({
	Name = "Quantum Tool Grabber",
	CurrentValue = false,
	Callback = function(state) _G.DW_ToolGrabber = state end
})

HomeTab:CreateToggle({
	Name = "Instant Respawn (Bypass Death)",
	CurrentValue = false,
	Callback = function(state) _G.DW_InstantRespawn = state end
})

HomeTab:CreateToggle({
	Name = "Anti-Spawn Kill (Escape Loopbring)",
	CurrentValue = false,
	Callback = function(state) _G.DW_AntiSpawnKill = state end
})

-- /* STREAMING_CHUNK:Targeting & Admin Tabs (Omitted for brevity, include your original tabs here) */

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

-- /* STREAMING_CHUNK:Integrated Tool Grabber.txt Logic */
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
	local inv = LocalPlayer.Backpack:FindFirstChild(toolName) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(toolName))
	return inv ~= nil
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

-- Master Loop
RunService.Heartbeat:Connect(function()
	if _G.DW_ToolGrabber then
		for toolName in pairs(toolToBase) do startToolLoop(toolName) end
	end
	
	-- Add your other Hitbox/Aura/Loopbring logic here
end)
