-- /* DEATH WATCHERS CLAN HUB - COMPREHENSIVE FIX & INTEGRATED KEY SYSTEM */
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ==================================================
-- 🔑 KEY SYSTEM CONFIGURATION
-- ==================================================
local CONFIG = {
    CorrectKey = "DW_SPEED_2026", -- Set your desired hub access key here
    DiscordLink = "https://discord.gg/deathwatchers"
}

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
_G.DW_AntiTouch = false         

-- Admin Loadstrings
local NamelessAdmin_Str = [[loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Nameless-admin-v250-script-87765"))()]]
local M7Admin_Str        = [[loadstring(game:HttpGet("https://mois7.xyz/loader"))()]]

-- Clipboard Helper
local function copyToClipboard(text)
    if setclipboard then setclipboard(text) elseif toclipboard then toclipboard(text) end
end

-- ==================================================
-- 🚀 MAIN HUB EXECUTION ENGINE
-- ==================================================
local function InitializeHub()
    -- Fetch the stable release of WindUI directly from the official GitHub mirror
    local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

    local Window = WindUI:CreateWindow({
        Title = "DEATH WATCHERS CLAN HUB",
        Icon = "skull",
        Author = "Clan OGS",
        Folder = "DeathWatchers",
        Size = UDim2.fromOffset(580, 520),
        Transparent = true,
        Theme = "Dark",
        SideBarWidth = 200,
        HasOutline = true
    })

    -- ==================================================
    -- ⚡ TOOL GRABBER CODE ENGINE (Referenced from Tool Grabber.txt)
    -- ==================================================
    local Tycoons = workspace:WaitForChild("Tycoons")
    local PAD_RANGE = 1000
    local TOUCH_BURST = 8 

    local allowedBases = {Stone=true, Magic=true, Storm=true, Robotic=true}
    local excludedBases = {Insanity=true, Giant=true, Dark=true, Spike=true, Web=true, Strong=true}

    local toolToBase = {
        ["Energy Sword"] = "Stone",
        ["Staff"] = "Magic",
        ["Axe"] = "Storm",
        ["Fist"] = "Robotic",
    }

    local padsByBase = {}
    local activeLoops = {}

    local function registerPad(pad)
        local base = pad.Parent and pad.Parent.Parent
        if not base then return end
        if excludedBases[base.Name] then return end
        if not allowedBases[base.Name] then return end

        padsByBase[base.Name] = padsByBase[base.Name] or {}
        table.insert(padsByBase[base.Name], pad)
    end

    for _, d in ipairs(Tycoons:GetDescendants()) do
        if d:IsA("TouchTransmitter") and d.Parent and d.Parent.Parent and d.Parent.Parent.Name:find("GearGiver1") then
            registerPad(d.Parent)
        end
    end

    Tycoons.DescendantAdded:Connect(function(d)
        if d:IsA("TouchTransmitter") and d.Parent and d.Parent.Parent and d.Parent.Parent.Name:find("GearGiver1") then
            registerPad(d.Parent)
        end
    end)

    local function hasTool(toolName)
        local function scan(container)
            if not container then return false end
            for _, t in ipairs(container:GetChildren()) do
                if t:IsA("Tool") and t.Name == toolName then return true end
            end
            return false
        end
        return scan(LocalPlayer.Backpack) or scan(LocalPlayer.Character)
    end

    local function tap(root, pad)
        pcall(firetouchinterest, root, pad, 0)
        pcall(firetouchinterest, root, pad, 1)
    end

    local function getClosestPad(pads, root)
        local closest, dist
        for _, pad in ipairs(pads) do
            local d = (pad.Position - root.Position).Magnitude
            if d < PAD_RANGE and (not dist or d < dist) then
                dist = d
                closest = pad
            end
        end
        return closest
    end

    local function startToolLoop(toolName)
        if activeLoops[toolName] then return end
        local base = toolToBase[toolName]
        if not base then return end

        activeLoops[toolName] = true

        task.spawn(function()
            while activeLoops[toolName] and _G.DW_ToolGrabber do
                if hasTool(toolName) then
                    activeLoops[toolName] = nil
                    break
                end

                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then
                    RunService.Heartbeat:Wait()
                    continue
                end

                local pads = padsByBase[base]
                if pads then
                    local pad = getClosestPad(pads, root)
                    if pad then
                        for i = 1, TOUCH_BURST do
                            tap(root, pad)
                        end
                    end
                end
                task.wait()
            end
            activeLoops[toolName] = nil
        end)
    end

    local function triggerGrabber()
        if not _G.DW_ToolGrabber then return end
        for toolName in pairs(toolToBase) do
            startToolLoop(toolName)
        end
    end

    -- ==================================================
    -- 💀 HARDENED GOD MODE & DAMAGE CONTEXT
    -- ==================================================
    local function RunGodMode()
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            local humanoid = character.Humanoid
            local clone = humanoid:Clone()
            
            clone.Parent = character
            humanoid:Destroy()
            LocalPlayer.Character = character
            workspace.CurrentCamera.CameraSubject = clone
            
            for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Parent = character
                    tool.Parent = LocalPlayer.Backpack
                end
            end
        end
    end

    local function damageCharacter(enemyChar, tool)
        local t = tool:FindFirstChildWhichIsA("TouchTransmitter", true)
        if t and firetouchinterest then
            for _, part in ipairs(enemyChar:GetChildren()) do
                if part:IsA("BasePart") then
                    pcall(firetouchinterest, t.Parent, part, 0)
                    pcall(firetouchinterest, t.Parent, part, 1)
                end
            end
        end
    end

    -- Zero-Delay Event Driven Equipper Execution
    LocalPlayer.Backpack.ChildAdded:Connect(function(child)
        if _G.DW_UseTools and child:IsA("Tool") then
            task.spawn(function()
                local char = LocalPlayer.Character
                if char then
                    child.Parent = char
                    pcall(child.Activate, child)
                    
                    if _G.DW_TargetAura or _G.DW_HitAmp then
                        local target = Players:FindFirstChild(_G.DW_TargetPlayer or "")
                        if target and target.Character then
                            damageCharacter(target.Character, child)
                        elseif _G.DW_HitAmp then
                            for _, p in ipairs(Players:GetPlayers()) do
                                if p ~= LocalPlayer and p.Character then
                                    damageCharacter(p.Character, child)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)

    -- Zero-Delay Fast Respawn Loop Core
    task.spawn(function()
        while true do
            if _G.DW_InstantRespawn then
                pcall(function()
                    if game:GetService("Players").RespawnTime ~= 0 then
                        game:GetService("Players").RespawnTime = 0
                    end
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health <= 0 then
                        LocalPlayer:RequestRespawn()
                    end
                end)
            end
            task.wait(0.01)
        end
    end)

    -- Handle Flag Triggers Across Respawns Safely
    local SpawnDeltWith = false
    task.spawn(function()
        local lastChar = nil
        while true do
            local char = LocalPlayer.Character
            if char and char ~= lastChar then
                lastChar = char
                SpawnDeltWith = false

                task.spawn(function()
                    local root = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")
                    if SpawnDeltWith then return end
                    SpawnDeltWith = true

                    if _G.DW_GodMode then pcall(RunGodMode) end
                    if _G.DW_ToolGrabber then triggerGrabber() end
                end)
            end
            task.wait(0.02)
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function(char)
        if SpawnDeltWith then return end
        SpawnDeltWith = true
        if _G.DW_GodMode then pcall(RunGodMode) end
        if _G.DW_ToolGrabber then triggerGrabber() end
    end)

    -- ==================================================
    -- UI TABS GENERATION
    -- ==================================================
    local HomeTab     = Window:Tab({ Title = "Home", Icon = "home" })
    local AntiTab     = Window:Tab({ Title = "Anti-Features", Icon = "shield" })
    local ImmunityTab = Window:Tab({ Title = "Immunity", Icon = "heart" })
    local TargetTab   = Window:Tab({ Title = "Targeting", Icon = "crosshair" })
    local ServerTab   = Window:Tab({ Title = "Server", Icon = "server" })
    local IdentityTab = Window:Tab({ Title = "Identity", Icon = "user" })
    local AdminTab    = Window:Tab({ Title = "Admin Scripts", Icon = "terminal" })

    HomeTab:Toggle({ Title = "Hitbox Expander (Size 10)", Desc = "Expands enemy hitboxes for easier reaching.", Default = false, Callback = function(s) _G.DW_Hitbox = s end })
    HomeTab:Toggle({ Title = "Hit Amplifier (Max Speed)", Desc = "Maximizes hit registration speeds.", Default = false, Callback = function(s) _G.DW_HitAmp = s end })
    HomeTab:Toggle({ Title = "Auto Use All Tools", Desc = "Instantly handles and activates inventory tools frame-one.", Default = false, Callback = function(s) _G.DW_UseTools = s end })
    HomeTab:Toggle({ 
        Title = "Quantum Tool Grabber", 
        Desc = "Instantly parallel-grabs tools configured from Tool Grabber.txt.", 
        Default = false, 
        Callback = function(s) 
            _G.DW_ToolGrabber = s 
            if s then triggerGrabber() end
        end 
    })
    HomeTab:Toggle({ Title = "Instant Respawn", Desc = "Forces custom client-sided immediate respawn loop.", Default = false, Callback = function(s) _G.DW_InstantRespawn = s end })
    HomeTab:Button({
        Title = "Enable No Cooldown",
        Callback = function()
            pcall(function() 
                hookfunction(wait, function() return RunService.PostSimulation:Wait() end) 
                hookfunction(task.wait, function() return RunService.PostSimulation:Wait() end) 
            end)
        end
    })

    AntiTab:Toggle({ Title = "Anti-Spawn Kill", Callback = function(s) _G.DW_AntiSpawnKill = s end })
    AntiTab:Toggle({ Title = "Anti-Loopbring", Callback = function(s) _G.DW_AntiLoopbring = s end })
    AntiTab:Toggle({ Title = "Anti-Kill Aura", Callback = function(s) _G.DW_AntiKillAura = s end })
    AntiTab:Toggle({ Title = "Anti-Targeted Aura (Shield)", Callback = function(s) _G.DW_AntiTargetAura = s end })
    AntiTab:Toggle({ Title = "Anti-Lag (Disable Effects)", Callback = function(s) _G.DW_AntiLag = s end })

    ImmunityTab:Toggle({ Title = "Ultimate God Mode", Desc = "Desynchronizes character structure to nullify incoming damage.", Default = false, Callback = function(s) _G.DW_GodMode = s if s then pcall(RunGodMode) end end })
    ImmunityTab:Toggle({ Title = "Anti-Touch Damage", Desc = "Locks local character parameters against .Touched sensors.", Default = false, Callback = function(s) _G.DW_AntiTouch = s end })

    local function GetPlayerNames() 
        local names = {} 
        for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(names, p.Name) end end 
        return names 
    end

    local TargetDropdown = TargetTab:Dropdown({ Title = "Select Target Player", Values = GetPlayerNames(), Default = "", Callback = function(v) _G.DW_TargetPlayer = v end })
    TargetTab:Button({ Title = "Refresh Player List", Callback = function() TargetDropdown:Refresh(GetPlayerNames()) end })
    TargetTab:Toggle({ Title = "Targeted Kill Aura", Callback = function(s) _G.DW_TargetAura = s end })
    TargetTab:Toggle({ Title = "Targeted Loopbring", Callback = function(s) _G.DW_Loopbring = s end })

    ServerTab:Button({ Title = "Rejoin Server", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end })
    ServerTab:Button({
        Title = "Server Hop",
        Callback = function()
            pcall(function()
                local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
                for _, v in pairs(servers.data) do
                    if v.playing < v.maxPlayers and v.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                        break
                    end
                end
            end)
        end
    })

    IdentityTab:Toggle({ Title = "Streamer / Hide Name Mode", Default = false, Callback = function(s) end })

    AdminTab:Button({ Title = "Execute Nameless Admin", Callback = function() pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Nameless-admin-v250-script-87765"))() end) end })
    AdminTab:Button({ Title = "Copy Nameless Admin Loadstring", Callback = function() copyToClipboard(NamelessAdmin_Str) end })
    AdminTab:Button({ Title = "Execute M7 Admin", Callback = function() pcall(function() loadstring(game:HttpGet("https://mois7.xyz/loader"))() end) end })
    AdminTab:Button({ Title = "Copy M7 Admin Loadstring", Callback = function() copyToClipboard(M7Admin_Str) end })

    -- Persistent Engine Loop Execution
    RunService.Heartbeat:Connect(function()
        local myChar = LocalPlayer.Character
        if not myChar then return end
        
        if _G.DW_AntiTouch then
            for _, part in ipairs(myChar:GetChildren()) do
                if part:IsA("BasePart") then part.CanTouch = false end
            end
        end

        if _G.DW_Hitbox then 
            for _, p in pairs(Players:GetPlayers()) do 
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
                    p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10) 
                    p.Character.HumanoidRootPart.CanCollide = false 
                end 
            end 
        end
        
        if _G.DW_TargetAura or _G.DW_HitAmp then
            local target = Players:FindFirstChild(_G.DW_TargetPlayer or "")
            
            if _G.DW_HitAmp and not (target and target.Character) then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        for _, tool in ipairs(myChar:GetChildren()) do
                            if tool:IsA("Tool") then damageCharacter(p.Character, tool) end
                        end
                    end
                end
            elseif target and target.Character then
                for _, tool in ipairs(myChar:GetChildren()) do
                    if tool:IsA("Tool") then damageCharacter(target.Character, tool) end
                end
            end
        end
    end)

    if LocalPlayer.Character and _G.DW_ToolGrabber then triggerGrabber() end

    WindUI:Notify({
        Title = "Access Granted",
        Content = "Welcome back, Death Watcher.",
        Duration = 4
    })
end

-- ==================================================
-- 🖥️ INSTANT NATIVE LUA KEY SYSTEM SCREEN
-- ==================================================
local function ConstructKeySystem()
    local targetParent = RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui") or CoreGui
    
    -- Prevent duplicate screens running concurrently
    if targetParent:FindFirstChild("DW_KeySystem") then
        targetParent.DW_KeySystem:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DW_KeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = targetParent

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderColor3 = Color3.fromRGB(45, 45, 55)
    MainFrame.BorderSizePixel = 1
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 340, 0, 220)
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 0, 0, 15)
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "DEATH WATCHERS KEY SYSTEM"
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
    TitleLabel.TextSize = 16
    TitleLabel.Parent = MainFrame

    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Name = "InfoLabel"
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Position = UDim2.new(0, 20, 0, 45)
    InfoLabel.Size = UDim2.new(1, -40, 0, 20)
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.Text = "Please enter your deployment key below to verify identity."
    InfoLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
    InfoLabel.TextSize = 11
    InfoLabel.Parent = MainFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Name = "KeyInput"
    KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    KeyInput.BorderColor3 = Color3.fromRGB(50, 50, 60)
    KeyInput.Position = UDim2.new(0, 30, 0, 85)
    KeyInput.Size = UDim2.new(1, -60, 0, 36)
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.PlaceholderText = "Paste Verification Key Here..."
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.TextSize = 13
    KeyInput.Parent = MainFrame

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 6)
    BoxCorner.Parent = KeyInput

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Name = "SubmitBtn"
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    SubmitBtn.BorderSizePixel = 0
    SubmitBtn.Position = UDim2.new(0, 30, 0, 140)
    SubmitBtn.Size = UDim2.new(0, 135, 0, 36)
	SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Text = "VERIFY KEY"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.TextSize = 12
    SubmitBtn.Parent = MainFrame

    local BtnCorner1 = Instance.new("UICorner")
    BtnCorner1.CornerRadius = UDim.new(0, 6)
    BtnCorner1.Parent = SubmitBtn

    local DiscordBtn = Instance.new("TextButton")
    DiscordBtn.Name = "DiscordBtn"
    DiscordBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    DiscordBtn.BorderSizePixel = 0
    DiscordBtn.Position = UDim2.new(1, -165, 0, 140)
    DiscordBtn.Size = UDim2.new(0, 135, 0, 36)
    DiscordBtn.Font = Enum.Font.GothamBold
    DiscordBtn.Text = "COPY DISCORD"
    DiscordBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
    DiscordBtn.TextSize = 12
    DiscordBtn.Parent = MainFrame

    local BtnCorner2 = Instance.new("UICorner")
    BtnCorner2.CornerRadius = UDim.new(0, 6)
    BtnCorner2.Parent = DiscordBtn

    -- Actions & Logic Connections
    DiscordBtn.MouseButton1Click:Connect(function()
        copyToClipboard(CONFIG.DiscordLink)
        DiscordBtn.Text = "COPIED LINK!"
        task.wait(1.5)
        DiscordBtn.Text = "COPY DISCORD"
    end)

    SubmitBtn.MouseButton1Click:Connect(function()
        if KeyInput.Text == CONFIG.CorrectKey then
            SubmitBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
            SubmitBtn.Text = "SUCCESS!"
            task.wait(0.5)
            ScreenGui:Destroy()
            InitializeHub()
        else
            SubmitBtn.Text = "INVALID KEY!"
            KeyInput.Text = ""
            task.wait(1.5)
            SubmitBtn.Text = "VERIFY KEY"
        end
    end)
end

-- Begin execution chain
ConstructKeySystem()
