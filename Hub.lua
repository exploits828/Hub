-- /* DEATH WATCHERS CLAN HUB - FULLY INTEGRATED & OPTIMIZED */
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

-- Safely Load Rayfield
local success, Rayfield = pcall(function() 
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))() 
end)

if not success then
    warn("DEATH WATCHERS: Failed to load Rayfield Library. Check internet or executor.")
    return
end

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
        Key = {"pvpOGS"}
    }
})

-- /* UI TABS */
local HomeTab = Window:CreateTab("Home", 4483362458)
HomeTab:CreateToggle({Name = "Hitbox Expander (Size 10)", Flag = "HitboxToggle", Callback = function(s) _G.DW_Hitbox = s end})
HomeTab:CreateToggle({Name = "Hit Amplifier (Max Speed)", Flag = "HitAmpToggle", Callback = function(s) _G.DW_HitAmp = s end})
HomeTab:CreateToggle({Name = "Auto Use All Tools", Flag = "UseToolsToggle", Callback = function(s) _G.DW_UseTools = s end})
HomeTab:CreateToggle({Name = "Quantum Tool Grabber", Flag = "ToolGrabberToggle", Callback = function(s) _G.DW_ToolGrabber = s end})
HomeTab:CreateToggle({Name = "Instant Respawn (Bypass Death)", Flag = "InstantRespawnToggle", Callback = function(s) _G.DW_InstantRespawn = s end})
HomeTab:CreateButton({Name = "Enable No Cooldown", Callback = function()
    pcall(function() hookfunction(wait, function() return RunService.PostSimulation:Wait() end) hookfunction(task.wait, function() return RunService.PostSimulation:Wait() end) end)
end})

local AntiTab = Window:CreateTab("Anti", 4483362458)
AntiTab:CreateToggle({Name = "Anti-Spawn Kill", Callback = function(s) _G.DW_AntiSpawnKill = s end})
AntiTab:CreateToggle({Name = "Anti-Loopbring", Callback = function(s) _G.DW_AntiLoopbring = s end})
AntiTab:CreateToggle({Name = "Anti-Kill Aura", Callback = function(s) _G.DW_AntiKillAura = s end})
AntiTab:CreateToggle({Name = "Anti-Targeted Aura (Shield)", Callback = function(s) _G.DW_AntiTargetAura = s end})
AntiTab:CreateToggle({Name = "Anti-Lag (Disable Effects)", Callback = function(s) _G.DW_AntiLag = s end})

local TargetTab = Window:CreateTab("Targeting", 4483362458)
local function GetPlayerNames() local names = {} for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(names, p.Name) end end return names end
local TargetDropdown = TargetTab:CreateDropdown({Name = "Select Target Player", Options = GetPlayerNames(), Callback = function(Option) _G.DW_TargetPlayer = Option[1] end})
TargetTab:CreateButton({Name = "Refresh Player List", Callback = function() TargetDropdown:Refresh(GetPlayerNames(), true) end})
TargetTab:CreateToggle({Name = "Targeted Kill Aura", Callback = function(s) _G.DW_TargetAura = s end})
TargetTab:CreateToggle({Name = "Targeted Loopbring", Callback = function(s) _G.DW_Loopbring = s end})

-- /* LOGIC */
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
                    if t then pcall(firetouchinterest, t.Parent, targetHRP, 0) pcall(firetouchinterest, t.Parent, targetHRP, 1) end 
                end
            end
        end
    end
end)

Rayfield:LoadConfiguration()
