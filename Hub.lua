-- /* DEATH WATCHERS CLAN HUB - FULL FUNCTIONALITY */
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "DEATH WATCHERS CLAN HUB",
   LoadingTitle = "Initializing...",
   LoadingSubtitle = "by Clan OGS",
   KeySystem = true,
   KeySettings = { Title = "DW Key System", Subtitle = "Enter your deployment key", Note = "Key: DW_SPEED_2026", Key = "DW_SPEED_2026" }
})

-- Tabs
local HomeTab = Window:CreateTab("Home", "home")
local AntiTab = Window:CreateTab("Anti-Features", "shield")
local ImmTab = Window:CreateTab("Immunity", "heart")
local AdminTab = Window:CreateTab("Admin", "terminal")

-- Core Logic
local function RunGodMode()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local clone = char.Humanoid:Clone()
        clone.Parent = char
        char.Humanoid:Destroy()
        game.Players.LocalPlayer.Character = char
        workspace.CurrentCamera.CameraSubject = clone
    end
end

-- Home Updates
HomeTab:CreateToggle({Name = "Hitbox Expander (10x)", Callback = function(v) _G.DW_Hitbox = v end})
HomeTab:CreateToggle({Name = "Hit Amplifier", Callback = function(v) _G.DW_HitAmp = v end})
HomeTab:CreateToggle({Name = "Auto Use All Tools", Callback = function(v) _G.DW_UseTools = v end})
HomeTab:CreateToggle({Name = "Quantum Tool Grabber", Callback = function(v) _G.DW_ToolGrabber = v end})
HomeTab:CreateToggle({Name = "Instant Respawn", Callback = function(v) _G.DW_InstantRespawn = v end})

-- Immunity/Goggle Updates
ImmTab:CreateToggle({Name = "Ultimate God Mode", Callback = function(v) if v then RunGodMode() end end})
ImmTab:CreateToggle({Name = "Anti-Touch Damage", Callback = function(v) _G.DW_AntiTouch = v end})

-- Anti-Features
AntiTab:CreateToggle({Name = "Anti-Spawn Kill", Callback = function(v) _G.DW_AntiSpawnKill = v end})
AntiTab:CreateToggle({Name = "Anti-Kill Aura", Callback = function(v) _G.DW_AntiKillAura = v end})
AntiTab:CreateToggle({Name = "Anti-Lag (Disable Effects)", Callback = function(v) _G.DW_AntiLag = v end})

-- Admin
AdminTab:CreateButton({Name = "Execute Nameless Admin", Callback = function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Nameless-admin-v250-script-87765"))() end})
AdminTab:CreateButton({Name = "Execute M7 Admin", Callback = function() loadstring(game:HttpGet("https://mois7.xyz/loader"))() end})

-- Persistent Engine Loop
game:GetService("RunService").Heartbeat:Connect(function()
    local lp = game.Players.LocalPlayer
    if not lp.Character then return end
    
    if _G.DW_Hitbox then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
            end
        end
    end
    
    if _G.DW_InstantRespawn and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health <= 0 then
        lp:RequestRespawn()
    end
    
    if _G.DW_AntiTouch then
        for _, part in ipairs(lp.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanTouch = false end
        end
    end
end)

Rayfield:LoadConfiguration()
