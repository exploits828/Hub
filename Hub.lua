# Death Watchers Clan Hub - Production Build
```lua
/* DEATH WATCHERS CLAN HUB - ORION EDITION V3 (PRODUCTION READY) */

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

-- Prevent multiple initializations
if _G.DW_INITIALIZED then return end
_G.DW_INITIALIZED = true

-- Load Orion Library (Corrected URL)
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexsoftware/Orion/main/source'))()

-- ============================================
-- AUTHENTICATION SYSTEM
-- ============================================
local CorrectKey = "pvpOGS"
local KeyWindow = OrionLib:MakeWindow({
    Name = "DEATH WATCHERS - Authentication",
    HidePremium = true,
    SaveConfig = false,
    IntroText = "Access Required"
})

local KeyTab = KeyWindow:MakeTab({
    Name = "Login",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local function InitializeMainHub()
    -- Destroy auth window only
    KeyWindow:Destroy()
    task.wait(0.3)
    
    -- Create main hub window
    local Window = OrionLib:MakeWindow({
        Name = "DEATH WATCHERS CLAN HUB",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "DWClanHub",
        IntroText = "Death Watchers Interface - Production Build"
    })

    -- ============================================
    -- HOME TAB
    -- ============================================
    local HomeTab = Window:MakeTab({
        Name = "Home",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
    
    HomeTab:AddToggle({
        Name = "Hitbox Expander (Size 10)",
        Default = false,
        Callback = function(s) _G.DW_Hitbox = s end
    })
    
    HomeTab:AddToggle({
        Name = "Hit Amplifier (Auto Activate)",
        Default = false,
        Callback = function(s) _G.DW_HitAmp = s end
    })
    
    HomeTab:AddToggle({
        Name = "Auto Use All Tools",
        Default = false,
        Callback = function(s) _G.DW_UseTools = s end
    })
    
    HomeTab:AddToggle({
        Name = "Quantum Tool Grabber",
        Default = false,
        Callback = function(s) _G.DW_ToolGrabber = s end
    })
    
    HomeTab:AddToggle({
        Name = "Instant Respawn (Bypass Death)",
        Default = false,
        Callback = function(s) _G.DW_InstantRespawn = s end
    })
    
    HomeTab:AddButton({
        Name = "Enable No Cooldown",
        Callback = function()
            pcall(function()
                hookfunction(wait, function() return RunService.PostSimulation:Wait() end)
                hookfunction(task.wait, function() return RunService.PostSimulation:Wait() end)
            end)
            OrionLib:MakeNotification({
                Name = "Success",
                Content = "No Cooldown Enabled",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    })

    -- ============================================
    -- ANTI TAB
    -- ============================================
    local AntiTab = Window:MakeTab({
        Name = "Anti",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
    
    AntiTab:AddToggle({
        Name = "God Mode (True Immortality)",
        Default = false,
        Callback = function(s) _G.DW_GodMode = s end
    })
    
    AntiTab:AddToggle({
        Name = "Anti-Spawn Kill",
        Default = false,
        Callback = function(s) _G.DW_AntiSpawnKill = s end
    })
    
    AntiTab:AddToggle({
        Name = "Anti-Loopbring",
        Default = false,
        Callback = function(s) _G.DW_AntiLoopbring = s end
    })
    
    AntiTab:AddToggle({
        Name = "Anti-Kill Aura",
        Default = false,
        Callback = function(s) _G.DW_AntiKillAura = s end
    })
    
    AntiTab:AddToggle({
        Name = "Anti-Targeted Aura (Shield)",
        Default = false,
        Callback = function(s) _G.DW_AntiTargetAura = s end
    })
    
    AntiTab:AddToggle({
        Name = "Anti-Lag (Disable Effects)",
        Default = false,
        Callback = function(s) _G.DW_AntiLag = s end
    })

    -- ============================================
    -- TARGETING TAB
    -- ============================================
    local TargetTab = Window:MakeTab({
        Name = "Targeting",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
    
    local function GetPlayerNames()
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(names, p.Name)
            end
        end
        return names
    end

    local TargetDropdown = TargetTab:AddDropdown({
        Name = "Select Target Player",
        Default = "",
        Options = GetPlayerNames(),
        Callback = function(Option)
            _G.DW_TargetPlayer = Option
        end
    })

    TargetTab:AddButton({
        Name = "Refresh Player List",
        Callback = function()
            TargetDropdown:Refresh(GetPlayerNames(), true)
        end
    })
    
    TargetTab:AddToggle({
        Name = "Targeted Kill Aura",
        Default = false,
        Callback = function(s) _G.DW_TargetAura = s end
    })
    
    TargetTab:AddToggle({
        Name = "Targeted Loopbring",
        Default = false,
        Callback = function(s) _G.DW_Loopbring = s end
    })

    -- ============================================
    -- ADMIN TAB
    -- ============================================
    local AdminTab = Window:MakeTab({
        Name = "Admin",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
    
    AdminTab:AddButton({
        Name = "Execute Nameless Admin",
        Callback = function()
            pcall(function()
                loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))()
            end)
        end
    })
    
    AdminTab:AddButton({
        Name = "Execute M7 Admin",
        Callback = function()
            pcall(function()
                loadstring(game:HttpGet("https://mois7.xyz/loader"))()
            end)
        end
    })

    -- ============================================
    -- SERVER TAB
    -- ============================================
    local ServerTab = Window:MakeTab({
        Name = "Server",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
    
    ServerTab:AddLabel("Latency: " .. math.floor(LocalPlayer:GetNetworkPing() * 1000) .. "ms")
    
    ServerTab:AddButton({
        Name = "Copy JobId",
        Callback = function()
            if setclipboard then
                setclipboard(game.JobId)
                OrionLib:MakeNotification({
                    Name = "Copied",
                    Content = "JobId copied to clipboard",
                    Image = "rbxassetid://4483345998",
                    Time = 2
                })
            end
        end
    })

    -- ============================================
    -- IDENTITY TAB
    -- ============================================
    local IdentityTab = Window:MakeTab({
        Name = "Identity",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
    
    IdentityTab:AddLabel("DisplayName: " .. LocalPlayer.DisplayName)
    IdentityTab:AddLabel("Username: " .. LocalPlayer.Name)
    IdentityTab:AddLabel("UserId: " .. tostring(LocalPlayer.UserId))

    -- ============================================
    -- MODULE: HIT AMPLIFIER (SMART SCAN)
    -- ============================================
    local overlapParams = OverlapParams.new()
    overlapParams.FilterType = Enum.RaycastFilterType.Exclude
    
    RunService.Heartbeat:Connect(function(dt)
        if not _G.DW_HitAmp then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        overlapParams.FilterDescendantsInstances = {char}
        local parts = workspace:GetPartBoundsInBox(hrp.CFrame, Vector3.new(28, 28, 28), overlapParams)
        
        for _, part in ipairs(parts) do
            local model = part:FindFirstAncestorOfClass("Model")
            if model then
                local hum = model:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool.ClassName == "Tool" then
                            pcall(tool.Activate, tool)
                        end
                    end
                    break
                end
            end
        end
    end)

    -- ============================================
    -- MODULE: QUANTUM INSTANT RESPAWN
    -- ============================================
    local function fireRespawn()
        pcall(function()
            local GuideEvent = ReplicatedStorage:FindFirstChild("Guide")
            if GuideEvent then
                GuideEvent:FireServer()
            else
                LocalPlayer:LoadCharacter()
            end
        end)
        
        task.delay(0.02, function()
            pcall(function()
                local GuideEvent = ReplicatedStorage:FindFirstChild("Guide")
                if GuideEvent then
                    GuideEvent:FireServer()
                else
                    LocalPlayer:LoadCharacter()
                end
            end)
        end)
    end

    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(function()
                if _G.DW_InstantRespawn then
                    fireRespawn()
                end
            end)
        end
    end

    LocalPlayer.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            hum.Died:Connect(function()
                if _G.DW_InstantRespawn then
                    fireRespawn()
                end
            end)
        end
    end)

    -- ============================================
    -- MODULE: QUANTUM TOOL GRABBER (SAFE VERSION)
    -- ============================================
    local padsByBase = {}
    local toolToBase = {
        ["Energy Sword"] = "Stone",
        ["Staff"] = "Magic",
        ["Axe"] = "Storm",
        ["Fist"] = "Robotic"
    }

    local Tycoons = workspace:WaitForChild("Tycoons", 10)
    
    if Tycoons then
        local function register(pad)
            local base = pad.Parent and pad.Parent.Parent
            if base then
                padsByBase[base.Name] = padsByBase[base.Name] or {}
                table.insert(padsByBase[base.Name], pad)
            end
        end

        for _, d in ipairs(Tycoons:GetDescendants()) do
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
    end

    -- ============================================
    -- MODULE: AUTO USE TOOLS
    -- ============================================
    task.spawn(function()
        while task.wait(0.1) do
            if _G.DW_UseTools and LocalPlayer.Character then
                for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool.ClassName == "Tool" then
                        tool.Parent = LocalPlayer.Character
                    end
                end
                for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                    if tool.ClassName == "Tool" then
                        pcall(tool.Activate, tool)
                    end
                end
            end
        end
    end)

    -- ============================================
    -- MODULE: ANTI-LAG
    -- ============================================
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

    -- ============================================
    -- CORE COMBAT LOOP (OPTIMIZED)
    -- ============================================
    RunService.Heartbeat:Connect(function()
        local myChar = LocalPlayer.Character
```
```lua
        if not myChar then return end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        local myHum = myChar:FindFirstChildOfClass("Humanoid")
        if not myHRP or not myHum then return end

        if _G.DW_GodMode then
            pcall(function()
                myHum.MaxHealth = math.huge
                if myHum.Health < myHum.MaxHealth then
                    myHum.Health = myHum.MaxHealth
                end
                for _, part in ipairs(myChar:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end

        if _G.DW_AntiSpawnKill then
            pcall(function()
                if myHum.Health > 0 and myHum.Health < (myHum.MaxHealth * 0.35) then
                    myHRP.CFrame = myHRP.CFrame + Vector3.new(0, 25, 0)
                end
            end)
        end

        local targetPlayer = nil
        local targetChar = nil
        local targetHRP = nil
        local targetHum = nil

        if _G.DW_TargetPlayer and _G.DW_TargetPlayer ~= "" then
            targetPlayer = Players:FindFirstChild(_G.DW_TargetPlayer)
            if targetPlayer and targetPlayer.Character then
                targetChar = targetPlayer.Character
                targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                targetHum = targetChar:FindFirstChildOfClass("Humanoid")
            end
        end

        if _G.DW_Hitbox then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        pcall(function()
                            hrp.Size = Vector3.new(10, 10, 10)
                            hrp.Transparency = 0.35
                            hrp.CanCollide = false
                            hrp.Massless = true
                        end)
                    end
                end
            end
        end

        if _G.DW_Loopbring and targetHRP and targetHum and targetHum.Health > 0 then
            pcall(function()
                targetHRP.CFrame = myHRP.CFrame * CFrame.new(0, 0, -4)
                targetHRP.AssemblyLinearVelocity = Vector3.zero
                targetHRP.AssemblyAngularVelocity = Vector3.zero
            end)
        end

        if _G.DW_TargetAura and targetHRP and targetHum and targetHum.Health > 0 then
            pcall(function()
                local offset = CFrame.new(0, 0, -3)
                myHRP.CFrame = targetHRP.CFrame * offset
                for _, tool in ipairs(myChar:GetChildren()) do
                    if tool:IsA("Tool") then
                        pcall(tool.Activate, tool)
                    end
                end
            end)
        end

        if _G.DW_AntiLoopbring then
            pcall(function()
                if targetHRP and (myHRP.Position - targetHRP.Position).Magnitude < 6 and not _G.DW_TargetAura and not _G.DW_Loopbring then
                    myHRP.CFrame = myHRP.CFrame + Vector3.new(0, 18, 0)
                end
            end)
        end

        if _G.DW_AntiKillAura then
            pcall(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                        if hrp and hum and hum.Health > 0 then
                            local dist = (myHRP.Position - hrp.Position).Magnitude
                            if dist < 8 then
                                myHRP.CFrame = myHRP.CFrame + Vector3.new(0, 12, 0)
                                break
                            end
                        end
                    end
                end
            end)
        end

        if _G.DW_AntiTargetAura and targetHRP and targetHum and targetHum.Health > 0 then
            pcall(function()
                local dist = (myHRP.Position - targetHRP.Position).Magnitude
                if dist < 10 then
                    myHRP.CFrame = myHRP.CFrame * CFrame.new(0, 14, 8)
                end
            end)
        end
    end)

    Players.PlayerRemoving:Connect(function(plr)
        if _G.DW_TargetPlayer == plr.Name then
            _G.DW_TargetPlayer = nil
            pcall(function()
                TargetDropdown:Refresh(GetPlayerNames(), true)
            end)
        end
    end)

    Players.PlayerAdded:Connect(function()
        task.wait(1)
        pcall(function()
            TargetDropdown:Refresh(GetPlayerNames(), true)
        end)
    end)

    OrionLib:MakeNotification({
        Name = "Loaded",
        Content = "Death Watchers Clan Hub initialized successfully",
        Image = "rbxassetid://4483345998",
        Time = 3
    })
end

KeyTab:AddTextbox({
    Name = "Enter Key",
    Default = "",
    TextDisappear = false,
    Callback = function(value)
        if value == CorrectKey then
            OrionLib:MakeNotification({
                Name = "Access Granted",
                Content = "Welcome to Death Watchers Clan Hub",
                Image = "rbxassetid://4483345998",
   
