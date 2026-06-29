-- /* STREAMING_CHUNK:Initializing Services & Rayfield */
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

-- /* STREAMING_CHUNK:Home Tab */
local HomeTab = Window:CreateTab("Home", 4483362458)
HomeTab:CreateToggle({Name = "Hitbox Expander (Size 10)", Flag = "HitboxToggle", Callback = function(state) _G.DW_Hitbox = state end})
HomeTab:CreateToggle({Name = "Hit Amplifier (Max Speed)", Flag = "HitAmpToggle", Callback = function(state) _G.DW_HitAmp = state end})
HomeTab:CreateToggle({Name = "Auto Use All Tools", Flag = "UseToolsToggle", Callback = function(state) _G.DW_UseTools = state end})
HomeTab:CreateToggle({Name = "Quantum Tool Grabber", Flag = "ToolGrabberToggle", Callback = function(state) _G.DW_ToolGrabber = state end})
HomeTab:CreateToggle({Name = "Instant Respawn (Bypass Death)", Flag = "InstantRespawnToggle", Callback = function(state) _G.DW_InstantRespawn = state end})
HomeTab:CreateButton({Name = "Enable No Cooldown", Callback = function()
    pcall(function() hookfunction(wait, function() return RunService.PostSimulation:Wait() end) hookfunction(task.wait, function() return RunService.PostSimulation:Wait() end) hookfunction(delay, function(_,func) task.spawn(func) end) hookfunction(spawn, function(func) task.spawn(func) end) end)
    Rayfield:Notify({Title = "Success", Content = "No Cooldown enabled globally.", Duration = 3})
end})

-- /* STREAMING_CHUNK:Anti Tab */
local AntiTab = Window:CreateTab("Anti", 4483362458)
AntiTab:CreateToggle({Name = "Anti-Spawn Kill", Callback = function(state) _G.DW_AntiSpawnKill = state end})
AntiTab:CreateToggle({Name = "Anti-Loopbring", Callback = function(state) _G.DW_AntiLoopbring = state end})
AntiTab:CreateToggle({Name = "Anti-Kill Aura", Callback = function(state) _G.DW_AntiKillAura = state end})
AntiTab:CreateToggle({Name = "Anti-Targeted Aura (Shield)", Callback = function(state) _G.DW_AntiTargetAura = state end})
AntiTab:CreateToggle({Name = "Anti-Lag (Disable Effects)", Callback = function(state) _G.DW_AntiLag = state end})

-- /* STREAMING_CHUNK:Targeting & Admin */
local TargetTab = Window:CreateTab("Targeting", 4483362458)
local function GetPlayerNames() local names = {} for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(names, p.Name) end end return names end
local TargetDropdown = TargetTab:CreateDropdown({Name = "Select Target Player", Options = GetPlayerNames(), Callback = function(Option) _G.DW_TargetPlayer = Option[1] end})
TargetTab:CreateButton({Name = "Refresh Player List", Callback = function() TargetDropdown:Refresh(GetPlayerNames(), true) end})
TargetTab:CreateToggle({Name = "Targeted Kill Aura", Callback = function(state) _G.DW_TargetAura = state end})
TargetTab:CreateToggle({Name = "Targeted Loopbring", Callback = function(state) _G.DW_Loopbring = state end})

local AdminTab = Window:CreateTab("Admin", 4483362458)
AdminTab:CreateButton({Name = "▶ Execute Nameless Admin", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))() end})
AdminTab:CreateButton({Name = "▶ Execute M7 Admin", Callback = function() loadstring(game:HttpGet("https://mois7.xyz/loader"))() end})

-- /* STREAMING_CHUNK:Server & Identity */
local ServerTab = Window:CreateTab("Server", 0)
ServerTab:CreateLabel("Latency: " .. math.floor(LocalPlayer:GetNetworkPing() * 1000) .. "ms")
ServerTab:CreateButton({Name = "Copy JobId", Callback = function() if setclipboard then setclipboard(game.JobId) end end})
local IdentityTab = Window:CreateTab("Identity", 0)
IdentityTab:CreateLabel("DisplayName: " .. LocalPlayer.DisplayName)
IdentityTab:CreateLabel("Username: " .. LocalPlayer.Name)

-- /* STREAMING_CHUNK:Core Module Logic */
RunService.Heartbeat:Connect(function()
    local myChar = LocalPlayer.Character
    if not myChar then return end

    if _G.DW_Hitbox then for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10) p.Character.HumanoidRootPart.Transparency = 0.9 p.Character.HumanoidRootPart.CanCollide = false end end end
    
    if (_G.DW_TargetAura or _G.DW_HitAmp) and (tick() - _G.LastAuraTick > 0.05) then
        _G.LastAuraTick = tick()
        local target = Players:FindFirstChild(_G.DW_TargetPlayer or "")
        local targetHRP = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        for _, tool in ipairs(myChar:GetChildren()) do
            if tool:IsA("Tool") then
                if _G.DW_HitAmp then pcall(tool.Activate, tool) end
                if _G.DW_TargetAura and targetHRP then local t = tool:FindFirstChildWhichIsA("TouchTransmitter", true) if t then pcall(firetouchinterest, t.Parent, targetHRP, 0) pcall(firetouchinterest, t.Parent, targetHRP, 1) end end
            end
        end
    end

    if _G.DW_AntiTargetAura then local hrp = myChar:FindFirstChild("HumanoidRootPart") if hrp then hrp.Velocity = Vector3.new(0, 0, 0) end end
    if _G.DW_AntiLag then for _, v in pairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end end end
end)

-- /* STREAMING_CHUNK:Quantum Tool Grabber */
local padsByBase = {["Stone"]={}, ["Magic"]={}, ["Storm"]={}, ["Robotic"]={}}
local toolToBase = {["Energy Sword"]="Stone", ["Staff"]="Magic", ["Axe"]="Storm", ["Fist"]="Robotic"}
for _, d in ipairs(workspace:WaitForChild("Tycoons"):GetDescendants()) do
    if d:IsA("TouchTransmitter") and d.Parent and d.Parent.Parent and d.Parent.Parent.Name:find("GearGiver1") then
        local base = d.Parent.Parent.Parent.Name
        if padsByBase[base] then table.insert(padsByBase[base], d.Parent) end
    end
end
task.spawn(function()
    while task.wait(0.5) do
        if _G.DW_ToolGrabber and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            for tName, bName in pairs(toolToBase) do
                if not (LocalPlayer.Backpack:FindFirstChild(tName) or LocalPlayer.Character:FindFirstChild(tName)) then
                    for _, pad in ipairs(padsByBase[bName]) do if (pad.Position - hrp.Position).Magnitude < 1000 then pcall(firetouchinterest, hrp, pad, 0) pcall(firetouchinterest, hrp, pad, 1) end end
                end
            end
        end
    end
end)
