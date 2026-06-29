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

-- /* STREAMING_CHUNK:Tabs Construction */
local HomeTab = Window:CreateTab("Home", 4483362458)
local CombatSection = HomeTab:CreateSection("Combat Modules")
HomeTab:CreateToggle({Name = "Hitbox Expander (Size 10)", Flag = "HitboxToggle", Callback = function(state) _G.DW_Hitbox = state end})
HomeTab:CreateToggle({Name = "Hit Amplifier (Max Speed)", Flag = "HitAmpToggle", Callback = function(state) _G.DW_HitAmp = state end})

local UtilitySection = HomeTab:CreateSection("Utility Modules")
HomeTab:CreateToggle({Name = "Auto Use All Tools", Flag = "UseToolsToggle", Callback = function(state) _G.DW_UseTools = state end})
HomeTab:CreateToggle({Name = "Quantum Tool Grabber", Flag = "ToolGrabberToggle", Callback = function(state) _G.DW_ToolGrabber = state end})
HomeTab:CreateToggle({Name = "Instant Respawn (Bypass Death)", Flag = "InstantRespawnToggle", Callback = function(state) _G.DW_InstantRespawn = state end})

-- /* STREAMING_CHUNK:New Anti Section */
local AntiTab = Window:CreateTab("Anti", 4483362458)
AntiTab:CreateToggle({Name = "Anti-Spawn Kill", Callback = function(state) _G.DW_AntiSpawnKill = state end})
AntiTab:CreateToggle({Name = "Anti-Loopbring", Callback = function(state) _G.DW_AntiLoopbring = state end})
AntiTab:CreateToggle({Name = "Anti-Kill Aura", Callback = function(state) _G.DW_AntiKillAura = state end})
AntiTab:CreateToggle({Name = "Anti-Targeted Aura (Shield)", Callback = function(state) _G.DW_AntiTargetAura = state end})
AntiTab:CreateToggle({Name = "Anti-Lag (Disable Effects)", Callback = function(state) 
    _G.DW_AntiLag = state
    if state then for _, v in pairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end end end
end})

-- /* STREAMING_CHUNK:Targeting & Admin */
local TargetTab = Window:CreateTab("Targeting", 4483362458)
local TargetDropdown = TargetTab:CreateDropdown({Name = "Select Target", Options = {}, Callback = function(Option) _G.DW_TargetPlayer = Option[1] end})
TargetTab:CreateToggle({Name = "Targeted Kill Aura", Flag = "TargetKillAura", Callback = function(state) _G.DW_TargetAura = state end})
TargetTab:CreateToggle({Name = "Targeted Loopbring", Flag = "TargetLoopbring", Callback = function(state) _G.DW_Loopbring = state end})

local AdminTab = Window:CreateTab("Admin", 4483362458)
AdminTab:CreateButton({Name = "Execute Nameless Admin", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))() end})
AdminTab:CreateButton({Name = "Execute M7 Admin", Callback = function() loadstring(game:HttpGet("https://mois7.xyz/loader"))() end})

-- /* STREAMING_CHUNK:Core Module Logic */
RunService.Heartbeat:Connect(function()
    local myChar = LocalPlayer.Character
    if not myChar then return end

    -- Optimized Kill Aura & Anti-Targeting
    if (_G.DW_TargetAura or _G.DW_HitAmp) and (tick() - _G.LastAuraTick > 0.05) then
        _G.LastAuraTick = tick()
        local targetPlayer = Players:FindFirstChild(_G.DW_TargetPlayer or "")
        local targetHRP = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        for _, tool in ipairs(myChar:GetChildren()) do
            if tool:IsA("Tool") then
                if _G.DW_HitAmp then pcall(tool.Activate, tool) end
                if _G.DW_TargetAura and targetHRP then
                    local touch = tool:FindFirstChildWhichIsA("TouchTransmitter", true)
                    if touch then pcall(firetouchinterest, touch.Parent, targetHRP, 0) pcall(firetouchinterest, touch.Parent, targetHRP, 1) end
                end
            end
        end
    end

    -- Anti-Targeted Aura (Shield)
    if _G.DW_AntiTargetAura then
        local hrp = myChar:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = Vector3.new(0, 0, 0) end
    end
end)

-- /* STREAMING_CHUNK:Tool Grabber */
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
                local has = (LocalPlayer.Backpack:FindFirstChild(tName) or LocalPlayer.Character:FindFirstChild(tName))
                if not has then
                    for _, pad in ipairs(padsByBase[bName]) do
                        if (pad.Position - hrp.Position).Magnitude < 1000 then pcall(firetouchinterest, hrp, pad, 0) pcall(firetouchinterest, hrp, pad, 1) end
                    end
                end
            end
        end
    end
end)
