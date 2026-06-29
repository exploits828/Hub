-- /* DEATH WATCHERS CLAN HUB - FULLY INTEGRATED */
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
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
_G.LastAuraTick = 0 

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
	Name = "DEATH WATCHERS CLAN HUB",
	LoadingTitle = "Death Watchers Interface",
	LoadingSubtitle = "Powered by Rayfield",
	Theme = "Default",
	DisableRayfieldPrompts = true,
	KeySystem = true,
	KeySettings = {Title = "Access Required", Subtitle = "Death Watchers Key System", Note = "Key: pvpOGS", FileName = "DW_Clan_Key", SaveKey = true, Key = {"pvpOGS"}}
})

-- /* HOME TAB */
local HomeTab = Window:CreateTab("Home", 4483362458)
HomeTab:CreateToggle({Name = "Hitbox Expander (Size 10)", Flag = "HitboxToggle", Callback = function(s) _G.DW_Hitbox = s end})
HomeTab:CreateToggle({Name = "Hit Amplifier (Max Speed)", Flag = "HitAmpToggle", Callback = function(s) _G.DW_HitAmp = s end})
HomeTab:CreateToggle({Name = "Auto Use All Tools", Flag = "UseToolsToggle", Callback = function(s) _G.DW_UseTools = s end})
HomeTab:CreateToggle({Name = "Quantum Tool Grabber", Flag = "ToolGrabberToggle", Callback = function(s) _G.DW_ToolGrabber = s end})
HomeTab:CreateToggle({Name = "Instant Respawn (Bypass Death)", Flag = "InstantRespawnToggle", Callback = function(s) _G.DW_InstantRespawn = s end})
HomeTab:CreateButton({Name = "Enable No Cooldown", Callback = function()
    pcall(function() hookfunction(wait, function() return RunService.PostSimulation:Wait() end) hookfunction(task.wait, function() return RunService.PostSimulation:Wait() end) end)
end})

-- /* ANTI TAB */
local AntiTab = Window:CreateTab("Anti", 4483362458)
AntiTab:CreateToggle({Name = "Anti-Spawn Kill", Callback = function(s) _G.DW_AntiSpawnKill = s end})
AntiTab:CreateToggle({Name = "Anti-Loopbring", Callback = function(s) _G.DW_AntiLoopbring = s end})
AntiTab:CreateToggle({Name = "Anti-Kill Aura", Callback = function(s) _G.DW_AntiKillAura = s end})
AntiTab:CreateToggle({Name = "Anti-Targeted Aura (Shield)", Callback = function(s) _G.DW_AntiTargetAura = s end})
AntiTab:CreateToggle({Name = "Anti-Lag (Disable Effects)", Callback = function(s) _G.DW_AntiLag = s end})

-- /* TARGETING TAB */
local TargetTab = Window:CreateTab("Targeting", 4483362458)
local function GetPlayerNames() local names = {} for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(names, p.Name) end end return names end
local TargetDropdown = TargetTab:CreateDropdown({Name = "Select Target Player", Options = GetPlayerNames(), Callback = function(Option) _G.DW_TargetPlayer = Option[1] end})
TargetTab:CreateButton({Name = "Refresh Player List", Callback = function() TargetDropdown:Refresh(GetPlayerNames(), true) end})
TargetTab:CreateToggle({Name = "Targeted Kill Aura", Callback = function(s) _G.DW_TargetAura = s end})
TargetTab:CreateToggle({Name = "Targeted Loopbring", Callback = function(s) _G.DW_Loopbring = s end})

-- /* ADMIN TAB */
local AdminTab = Window:CreateTab("Admin", 4483362458)
AdminTab:CreateButton({Name = "▶ Execute Nameless Admin", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))() end})
AdminTab:CreateButton({Name = "▶ Execute M7 Admin", Callback = function() loadstring(game:HttpGet("https://mois7.xyz/loader"))() end})

-- /* SERVER & IDENTITY */
local ServerTab = Window:CreateTab("Server", 0)
ServerTab:CreateLabel("Latency: " .. math.floor(LocalPlayer:GetNetworkPing() * 1000) .. "ms")
ServerTab:CreateButton({Name = "Copy JobId", Callback = function() if setclipboard then setclipboard(game.JobId) end end})

local IdentityTab = Window:CreateTab("Identity", 0)
IdentityTab:CreateLabel("DisplayName: " .. LocalPlayer.DisplayName)
IdentityTab:CreateLabel("Username: " .. LocalPlayer.Name)

-- /* MODULE LOGIC: Hit Amplifier (Smart Scan) */
local overlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Exclude
RunService.Heartbeat:Connect(function(dt)
    if not _G.DW_HitAmp then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    overlapParams.FilterDescendantsInstances = {char}
    local parts = workspace:GetPartBoundsInBox(hrp.CFrame, Vector3.new(28,28,28), overlapParams)
    for _, part in ipairs(parts) do
        local model = part:FindFirstAncestorOfClass("Model")
        if model then
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                for _, tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") then pcall(tool.Activate, tool) end end
                break
            end
        end
    end
end)

-- /* MODULE LOGIC: Quantum Instant Respawn */
local GuideEvent = ReplicatedStorage:FindFirstChild("Guide")
local function fireRespawn()
    pcall(function() if GuideEvent then GuideEvent:FireServer() else LocalPlayer:LoadCharacter() end end)
    task.delay(0.02, function() pcall(function() if GuideEvent then GuideEvent:FireServer() else LocalPlayer:LoadCharacter() end end) end)
end
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        hum.Died:Connect(function() if _G.DW_InstantRespawn then fireRespawn() end end)
    end
end)

-- /* MODULE LOGIC: Quantum Tool Grabber */
local padsByBase = {}
local toolToBase = {["Energy Sword"]="Stone", ["Staff"]="Magic", ["Axe"]="Storm", ["Fist"]="Robotic"}
local function register(pad) local base = pad.Parent and pad.Parent.Parent if base then padsByBase[base.Name] = padsByBase[base.Name] or {} table.insert(padsByBase[base.Name], pad) end end
for _,d in ipairs(workspace:WaitForChild("Tycoons"):GetDescendants()) do if d:IsA("TouchTransmitter") and d.Parent and d.Parent.Parent and d.Parent.Parent.Name:find("GearGiver1") then register(d.Parent) end end
task.spawn(function()
    while task.wait(0.5) do
        if _G.DW_ToolGrabber and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            for tName, bName in pairs(toolToBase) do
                if not (LocalPlayer.Backpack:FindFirstChild(tName) or LocalPlayer.Character:FindFirstChild(tName)) then
                    for _, pad in ipairs(padsByBase[bName] or {}) do
                        pcall(firetouchinterest, root, pad, 0) pcall(firetouchinterest, root, pad, 1)
                    end
                end
            end
        end
    end
end)

-- /* MODULE LOGIC: Miscellaneous (Anti/AutoUse) */
task.spawn(function()
    while task.wait(0.1) do
        if _G.DW_UseTools and LocalPlayer.Character then
            for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do if tool:IsA("Tool") then tool.Parent = LocalPlayer.Character end end
            for _, tool in pairs(LocalPlayer.Character:GetChildren()) do if tool:IsA("Tool") then pcall(tool.Activate, tool) end end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local myChar = LocalPlayer.Character
    if not myChar then return end
    if _G.DW_Hitbox then for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10) p.Character.HumanoidRootPart.CanCollide = false end end end
    if (_G.DW_TargetAura or _G.DW_HitAmp) and (tick() - _G.LastAuraTick > 0.05) then
        _G.LastAuraTick = tick()
        local target = Players:FindFirstChild(_G.DW_TargetPlayer or "")
        local targetHRP = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        for _, tool in ipairs(myChar:GetChildren()) do
            if tool:IsA("Tool") then
                if _G.DW_TargetAura and targetHRP then local t = tool:FindFirstChildWhichIsA("TouchTransmitter", true) if t then pcall(firetouchinterest, t.Parent, targetHRP, 0) pcall(firetouchinterest, t.Parent, targetHRP, 1) end end
            end
        end
    end
    if _G.DW_AntiTargetAura then local hrp = myChar:FindFirstChild("HumanoidRootPart") if hrp then hrp.Velocity = Vector3.new(0, 0, 0) end end
    if _G.DW_AntiLag then for _, v in pairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end end end
end)
