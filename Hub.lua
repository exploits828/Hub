-- /* DEATH WATCHERS CLAN HUB - ORION EDITION V2 (FULLY INTEGRATED & OPTIMIZED) */
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
_G.DW_GodMode = false

-- Load Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexsoftware/Orion/main/source')))()

-- /* CUSTOM KEY SYSTEM */
local CorrectKey = "pvpOGS"
local KeyWindow = OrionLib:MakeWindow({Name = "DEATH WATCHERS - Auth", HidePremium = true, SaveConfig = false, IntroText = "Access Required"})
local KeyTab = KeyWindow:MakeTab({Name = "Login", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local function LoadMainHub()
    OrionLib:Destroy()
    task.wait(0.2)
    
    -- Re-initialize Orion for the main hub
    OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexsoftware/Orion/main/source')))()
    local Window = OrionLib:MakeWindow({
        Name = "DEATH WATCHERS CLAN HUB",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "DWClanHub",
        IntroText = "Death Watchers Interface"
    })

    -- /* HOME TAB */
    local HomeTab = Window:MakeTab({Name = "Home", Icon = "rbxassetid://4483345998", PremiumOnly = false})
    HomeTab:AddToggle({Name = "Hitbox Expander (Size 10)", Default = false, Callback = function(s) _G.DW_Hitbox = s end})
    HomeTab:AddToggle({Name = "Hit Amplifier (Max Speed)", Default = false, Callback = function(s) _G.DW_HitAmp = s end})
    HomeTab:AddToggle({Name = "Auto Use All Tools", Default = false, Callback = function(s) _G.DW_UseTools = s end})
    HomeTab:AddToggle({Name = "Quantum Tool Grabber", Default = false, Callback = function(s) _G.DW_ToolGrabber = s end})
    HomeTab:AddToggle({Name = "Instant Respawn (Bypass Death)", Default = false, Callback = function(s) _G.DW_InstantRespawn = s end})
    HomeTab:AddButton({Name = "Enable No Cooldown", Callback = function()
        pcall(function() hookfunction(wait, function() return RunService.PostSimulation:Wait() end) hookfunction(task.wait, function() return RunService.PostSimulation:Wait() end) end)
    end})

    -- /* ANTI TAB */
    local AntiTab = Window:MakeTab({Name = "Anti", Icon = "rbxassetid://4483345998", PremiumOnly = false})
    AntiTab:AddToggle({Name = "God Mode (True Immortality)", Default = false, Callback = function(s) _G.DW_GodMode = s end})
    AntiTab:AddToggle({Name = "Anti-Spawn Kill", Default = false, Callback = function(s) _G.DW_AntiSpawnKill = s end})
    AntiTab:AddToggle({Name = "Anti-Loopbring", Default = false, Callback = function(s) _G.DW_AntiLoopbring = s end})
    AntiTab:AddToggle({Name = "Anti-Kill Aura", Default = false, Callback = function(s) _G.DW_AntiKillAura = s end})
    AntiTab:AddToggle({Name = "Anti-Targeted Aura (Shield)", Default = false, Callback = function(s) _G.DW_AntiTargetAura = s end})
    AntiTab:AddToggle({Name = "Anti-Lag (Disable Effects)", Default = false, Callback = function(s) _G.DW_AntiLag = s end})

    -- /* TARGETING TAB */
    local TargetTab = Window:MakeTab({Name = "Targeting", Icon = "rbxassetid://4483345998", PremiumOnly = false})
    local function GetPlayerNames() 
        local names = {} 
        for _, p in ipairs(Players:GetPlayers()) do 
            if p ~= LocalPlayer then table.insert(names, p.Name) end 
        end 
        return names 
    end

    local TargetDropdown = TargetTab:AddDropdown({
        Name = "Select Target Player",
        Default = "",
        Options = GetPlayerNames(),
        Callback = function(Option) _G.DW_TargetPlayer = Option end
    })

    TargetTab:AddButton({Name = "Refresh Player List", Callback = function() TargetDropdown:Refresh(GetPlayerNames(), true) end})
    TargetTab:AddToggle({Name = "Targeted Kill Aura", Default = false, Callback = function(s) _G.DW_TargetAura = s end})
    TargetTab:AddToggle({Name = "Targeted Loopbring", Default = false, Callback = function(s) _G.DW_Loopbring = s end})

    -- /* ADMIN TAB */
    local AdminTab = Window:MakeTab({Name = "Admin", Icon = "rbxassetid://4483345998", PremiumOnly = false})
    AdminTab:AddButton({Name = "▶ Execute Nameless Admin", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))() end})
    AdminTab:AddButton({Name = "▶ Execute M7 Admin", Callback = function() loadstring(game:HttpGet("https://mois7.xyz/loader"))() end})

    -- /* SERVER & IDENTITY */
    local ServerTab = Window:MakeTab({Name = "Server", Icon = "rbxassetid://4483345998", PremiumOnly = false})
    ServerTab:AddLabel("Latency: " .. math.floor(LocalPlayer:GetNetworkPing() * 1000) .. "ms")
    ServerTab:AddButton({Name = "Copy JobId", Callback = function() if setclipboard then setclipboard(game.JobId) end end})

    local IdentityTab = Window:MakeTab({Name = "Identity", Icon = "rbxassetid://4483345998", PremiumOnly = false})
    IdentityTab:AddLabel("DisplayName: " .. LocalPlayer.DisplayName)
    IdentityTab:AddLabel("Username: " .. LocalPlayer.Name)

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
                    for _, tool in ipairs(char:GetChildren()) do if tool.ClassName == "Tool" then pcall(tool.Activate, tool) end end
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

    -- /* MODULE LOGIC: Quantum Tool Grabber (DYNAMIC FIX) */
    local padsByBase = {}
    local toolToBase = {["Energy Sword"]="Stone", ["Staff"]="Magic", ["Axe"]="Storm", ["Fist"]="Robotic"}
    local Tycoons = workspace:WaitForChild("Tycoons")

    local function register(pad) 
        local base = pad.Parent and pad.Parent.Parent 
        if base then 
            padsByBase[base.Name] = padsByBase[base.Name] or {} 
            table.insert(padsByBase[base.Name], pad) 
        end 
    end

    for _,d in ipairs(Tycoons:GetDescendants()) do 
        if d.ClassName == "TouchTransmitter" and d.Parent and d.Parent.Parent and d.Parent.Parent.Name:find("GearGiver1") then 
            register(d.Parent) 
        end 
    end

    Tycoons.DescendantAdded:Connect(function(d)
        if d.ClassName == "TouchTransmitter" and d.Parent and d.Parent.Parent and d.Parent.Parent.Name:find("GearGiver1") then
            register(d.Parent)
        end
    end)

    task.spawn(function()
        while task.wait(0.5) do
            if _G.DW_ToolGrabber then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local root = char.HumanoidRootPart
                    local backpack = LocalPlayer:FindFirstChild("Backpack")
                    
                    if backpack then
                        for tName, bName in pairs(toolToBase) do
                            if not (backpack:FindFirstChild(tName) or char:FindFirstChild(tName)) then
                                for _, pad in ipairs(padsByBase[bName] or {}) do
                                    if pad and pad.Parent then
                                        pcall(firetouchinterest, root, pad, 0) 
                                        pcall(firetouchinterest, root, pad, 1)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    -- /* MODULE LOGIC: Miscellaneous (AutoUse & AntiLag Thread) */
    task.spawn(function()
        while task.wait(0.1) do
            if _G.DW_UseTools and LocalPlayer.Character then
                for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do if tool.ClassName == "Tool" then tool.Parent = LocalPlayer.Character end end
                for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do if tool.ClassName == "Tool" then pcall(tool.Activate, tool) end end
            end
        end
    end)

    task.spawn(function()
        while task.wait(2) do
            if _G.DW_AntiLag then 
                for _, v in ipairs(workspace:GetDescendants()) do 
                    if v.ClassName == "ParticleEmitter" or v.ClassName == "Trail" then 
                        v.Enabled = false 
                    end 
                end 
            end
        end
    end)

    -- /* HIGH PERFORMANCE CORE COMBAT LOOP (OPTIMIZED VEGA X) */
    RunService.Heartbeat:Connect(function()
        local myChar = LocalPlayer.Character
        if not myChar then return end
        
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        local myHum = myChar:FindFirstChild("Humanoid")
        
        -- GOD MODE LOGIC (TRUE IMMORTALITY)
        if _G.DW_GodMode then
            if myHum then 
                myHum.Health = myHum.MaxHealth 
                myHum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                myHum.BreakJointsOnDeath = false
            end
            local ff = myChar:FindFirstChildOfClass("ForceField")
            if not ff then
                local newFF = Instance.new("ForceField")
                newFF.Visible = false
                newFF.Parent = myChar
            end
        elseif not _G.DW_GodMode then
            if myHum then 
                myHum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                myHum.BreakJointsOnDeath = true
            end
            local ff = myChar:FindFirstChildOfClass("ForceField")
            if ff and ff.Visible == false then ff:Destroy() end
        end
        
        if _G.DW_Hitbox then 
            for _, p in ipairs(Players:GetPlayers()) do 
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
                    p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10) 
                    p.Character.HumanoidRootPart.CanCollide = false 
                end 
            end 
        end
        
        local target = _G.DW_TargetPlayer and Players:FindFirstChild(_G.DW_TargetPlayer)
        local targetHRP = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")

        -- 1. Loopbring
        if _G.DW_Loopbring and targetHRP and myHRP then
            targetHRP.CFrame = myHRP.CFrame * CFrame.new(0, 0, -3) 
            targetHRP.AssemblyLinearVelocity = Vector3.new(0,0,0)
            targetHRP.AssemblyAngularVelocity = Vector3.new(0,0,0)
        end

        -- 2. Kill Aura
        if _G.DW_TargetAura and targetHRP then
            for _, tool in ipairs(myChar:GetChildren()) do
                if tool.ClassName == "Tool" then
                    local t = tool:FindFirstChildWhichIsA("TouchTransmitter", true)
                    if t then 
                        local handle = t.Parent
                        for i = 1, 8 do 
                            firetouchinterest(handle, targetHRP, 0) 
                            firetouchinterest(handle, targetHRP, 1) 
                        end
                    end
                end
            end
        end

        -- 3. Defensive Mechanics
        if _G.DW_AntiTargetAura and myHRP then 
            myHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0) 
        end
    end)

    OrionLib:Init()
end

-- Key Input Trigger
KeyTab:AddTextbox({
    Name = "Enter Clan Key",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        if Value == CorrectKey then
            LoadMainHub()
        else
            OrionLib:MakeNotification({
                Name = "Access Denied",
                Content = "Invalid Key. Please try again.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

OrionLib:Init()
