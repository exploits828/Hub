-- /* DEATH WATCHERS CLAN HUB - INTEGRATED */
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Global States
_G.DW_TargetPlayer = nil
_G.DW_Hitbox = false
_G.DW_HitAmp = false
_G.DW_ToolGrabber = false
_G.DW_InstantRespawn = false
_G.DW_TargetAura = false
_G.DW_AntiTargetAura = false
_G.DW_AntiLag = false

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "DEATH WATCHERS CLAN HUB",
    LoadingTitle = "Initializing Systems...",
    Theme = "Default",
    KeySystem = true,
    KeySettings = {Title = "Access Required", Key = {"pvpOGS"}}
})

-- /* HOME TAB */
local HomeTab = Window:CreateTab("Home", 4483362458)
HomeTab:CreateToggle({Name = "Hitbox Expander", Callback = function(s) _G.DW_Hitbox = s end})
HomeTab:CreateToggle({Name = "Hit Amplifier (Smart Scan)", Callback = function(s) _G.DW_HitAmp = s end})
HomeTab:CreateToggle({Name = "Quantum Tool Grabber", Callback = function(s) _G.DW_ToolGrabber = s end})
HomeTab:CreateToggle({Name = "Instant Respawn (Fast)", Callback = function(s) _G.DW_InstantRespawn = s end})

-- /* ANTI TAB */
local AntiTab = Window:CreateTab("Anti", 4483362458)
AntiTab:CreateToggle({Name = "Anti-Targeted Shield", Callback = function(s) _G.DW_AntiTargetAura = s end})
AntiTab:CreateToggle({Name = "Anti-Lag", Callback = function(s) _G.DW_AntiLag = s end})

-- /* TARGETING TAB */
local TargetTab = Window:CreateTab("Targeting", 4483362458)
local function GetNames() local n = {} for _,p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(n, p.Name) end end return n end
local Drop = TargetTab:CreateDropdown({Name = "Select Target", Options = GetNames(), Callback = function(o) _G.DW_TargetPlayer = o[1] end})
TargetTab:CreateButton({Name = "Refresh Player List", Callback = function() Drop:Refresh(GetNames(), true) end})
TargetTab:CreateToggle({Name = "Targeted Kill Aura", Callback = function(s) _G.DW_TargetAura = s end})

-- /* SERVER/IDENTITY */
local ServerTab = Window:CreateTab("Server", 0)
ServerTab:CreateLabel("Latency: " .. math.floor(LocalPlayer:GetNetworkPing() * 1000) .. "ms")
ServerTab:CreateButton({Name = "Copy JobId", Callback = function() if setclipboard then setclipboard(game.JobId) end end})

-- /* MODULE LOGIC */

-- HIT AMPLIFIER (Integrated Source 5)
RunService.Heartbeat:Connect(function(dt)
    if not _G.DW_HitAmp then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local parts = workspace:GetPartBoundsInBox(hrp.CFrame, Vector3.new(28,28,28))
    for _, part in ipairs(parts) do
        local model = part:FindFirstAncestorOfClass("Model")
        if model and model ~= char then
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then pcall(tool.Activate, tool) end
                end
                break
            end
        end
    end
end)

-- QUANTUM INSTANT RESPAWN (Integrated Source 4)
local GuideEvent = ReplicatedStorage:FindFirstChild("Guide")
local function fireRespawn()
    pcall(function() if GuideEvent then GuideEvent:FireServer() else LocalPlayer:LoadCharacter() end end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    if _G.DW_InstantRespawn then
        local hum = char:WaitForChild("Humanoid")
        hum.Died:Connect(function()
            if _G.DW_InstantRespawn then fireRespawn() end
        end)
    end
end)

-- QUANTUM TOOL GRABBER (Integrated Source 3)
local toolToBase = {["Energy Sword"]="Stone", ["Staff"]="Magic", ["Axe"]="Storm", ["Fist"]="Robotic"}
task.spawn(function()
    while task.wait(0.5) do
        if _G.DW_ToolGrabber and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for tName, bName in pairs(toolToBase) do
                    if not (LocalPlayer.Backpack:FindFirstChild(tName) or LocalPlayer.Character:FindFirstChild(tName)) then
                        for _, pad in ipairs(workspace:GetDescendants()) do
                            if pad:IsA("TouchTransmitter") and pad.Parent.Parent.Name == bName then
                                pcall(firetouchinterest, root, pad.Parent, 0)
                                pcall(firetouchinterest, root, pad.Parent, 1)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- CORE TARGETING AURA
RunService.Heartbeat:Connect(function()
    if _G.DW_TargetAura and _G.DW_TargetPlayer then
        local target = Players:FindFirstChild(_G.DW_TargetPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    local t = tool:FindFirstChildWhichIsA("TouchTransmitter", true)
                    if t then pcall(firetouchinterest, t.Parent, target.Character.HumanoidRootPart, 0) end
                end
            end
        end
    end
end)
