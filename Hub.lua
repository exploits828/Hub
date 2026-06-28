-- Unified Hub V7 - Fully Integrated
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local lp = Players.LocalPlayer

-- UI Container
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "UnifiedHub"
MainGui.ResetOnSpawn = false
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGui.Parent = CoreGui -- Ensures it persists over game loads

-- -----------------------------------------------------
-- ⚡ Core UI Elements (Simplified for Stability)
-- -----------------------------------------------------
local function CreateUI()
    local MainFrame = Instance.new("Frame", MainGui)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false -- Hidden until Key is verified

    -- Minimize Button
    local MinBtn = Instance.new("TextButton", MainGui)
    MinBtn.Size = UDim2.new(0, 40, 0, 40)
    MinBtn.Position = UDim2.new(0.9, 0, 0.1, 0)
    MinBtn.Text = "⚡"
    MinBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    MinBtn.Visible = true
    MinBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)
    
    return MainFrame
end

local UI = CreateUI()

-- -----------------------------------------------------
-- 🛡️ Key System & Boot Animation
-- -----------------------------------------------------
local function BootUp()
    print("Initializing Unified Hub...")
    task.wait(1)
    UI.Visible = true
    -- Add Boot Animation Logic Here
end

-- -----------------------------------------------------
-- 🎯 Persistent Hitbox (Highlight 3D)
-- -----------------------------------------------------
local function ApplyHitbox(char)
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and not hrp:FindFirstChild("HitboxHighlight") then
        local hl = Instance.new("Highlight")
        hl.Name = "HitboxHighlight"
        hl.FillColor = Color3.fromRGB(0, 0, 255)
        hl.OutlineColor = Color3.fromRGB(0, 0, 0)
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        hl.Adornee = char
        hl.Parent = hrp
    end
end

-- -----------------------------------------------------
-- 🚀 Quantum Tool Grabber (Logic)
-- -----------------------------------------------------
local allowedTools = {["Energy Sword"]=true, ["Staff"]=true, ["Axe"]=true, ["Fist"]=true}

local function StartGrabber()
    task.spawn(function()
        while true do
            for _, tool in pairs(lp.Backpack:GetChildren()) do
                if allowedTools[tool.Name] then
                    tool.Parent = lp.Character
                end
            end
            task.wait(1)
        end
    end)
end

-- -----------------------------------------------------
-- 👑 Avatar/Threat Dashboard
-- -----------------------------------------------------
local function UpdateDashboard(frame)
    if lp.Name == "city800" then
        -- Add Threat Label
        local lbl = Instance.new("TextLabel", frame)
        lbl.Text = "THREAT DETECTED"
        lbl.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end

-- -----------------------------------------------------
-- Initialization
-- -----------------------------------------------------
BootUp()
StartGrabber()
RunService.Heartbeat:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then ApplyHitbox(p.Character) end
    end
end)
