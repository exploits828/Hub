-- STREAMING_CHUNK: Initializing Core Services and Settings...
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local KEY = "pvpOGS"

-- Arceus X / Dark Acrylic Theme
local Theme = {
Background = Color3.fromRGB(12, 12, 14),
Surface = Color3.fromRGB(20, 20, 23),
Outline = Color3.fromRGB(35, 35, 40),
Accent = Color3.fromRGB(0, 255, 128), -- Cyber Green
Threat = Color3.fromRGB(255, 45, 45), -- Crimson Red
TextPrimary = Color3.fromRGB(255, 255, 255),
TextSecondary = Color3.fromRGB(150, 150, 160),
ToggleOff = Color3.fromRGB(45, 45, 50)
}

-- Destroy old instances to prevent overlapping
if CoreGui:FindFirstChild("UnifiedHub_Arceus") then
CoreGui:FindFirstChild("UnifiedHub_Arceus"):Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "UnifiedHub_Arceus"
gui.Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Helper for rounded corners
local function AddCorner(parent, radius)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, radius)
corner.Parent = parent
return corner
end

-- STREAMING_CHUNK: Building the Key Verification Interface...
local KeyFrame = Instance.new("Frame", gui)
KeyFrame.Size = UDim2.new(0, 350, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
KeyFrame.BackgroundColor3 = Theme.Background
KeyFrame.BorderSizePixel = 0
AddCorner(KeyFrame, 8)

local KeyStroke = Instance.new("UIStroke", KeyFrame)
KeyStroke.Color = Theme.Outline
KeyStroke.Thickness = 1

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.Text = ">_ AUTHENTICATION"
KeyTitle.Font = Enum.Font.CodeBold
KeyTitle.TextSize = 20
KeyTitle.TextColor3 = Theme.Accent
KeyTitle.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0, 45)
KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyInput.BackgroundColor3 = Theme.Surface
KeyInput.TextColor3 = Theme.TextPrimary
KeyInput.Font = Enum.Font.Code
KeyInput.TextSize = 16
KeyInput.PlaceholderText = "ENTER ACCESS KEY"
KeyInput.Text = ""
AddCorner(KeyInput, 6)
local InputStroke = Instance.new("UIStroke", KeyInput)
InputStroke.Color = Theme.Outline
InputStroke.Thickness = 1

local KeySubmit = Instance.new("TextButton", KeyFrame)
KeySubmit.Size = UDim2.new(0.8, 0, 0, 45)
KeySubmit.Position = UDim2.new(0.1, 0, 0.65, 0)
KeySubmit.BackgroundColor3 = Theme.Accent
KeySubmit.Text = "DECRYPT"
KeySubmit.Font = Enum.Font.CodeBold
KeySubmit.TextSize = 18
KeySubmit.TextColor3 = Color3.fromRGB(0, 0, 0)
AddCorner(KeySubmit, 6)

-- STREAMING_CHUNK: Building the Main Dashboard and Threat Overlay...
local MainHub = Instance.new("Frame", gui)
MainHub.Size = UDim2.new(0, 600, 0, 400)
MainHub.Position = UDim2.new(0.5, -300, 0.5, -200)
MainHub.BackgroundColor3 = Theme.Background
MainHub.Visible = false
AddCorner(MainHub, 12)
local MainStroke = Instance.new("UIStroke", MainHub)
MainStroke.Color = Theme.Outline
MainStroke.Thickness = 1

-- Avatar Profile Card (Left Side)
local ProfileCard = Instance.new("Frame", MainHub)
ProfileCard.Size = UDim2.new(0, 180, 1, -20)
ProfileCard.Position = UDim2.new(0, 10, 0, 10)
ProfileCard.BackgroundColor3 = Theme.Surface
AddCorner(ProfileCard, 10)

local AvatarImage = Instance.new("ImageLabel", ProfileCard)
AvatarImage.Size = UDim2.new(0, 100, 0, 100)
AvatarImage.Position = UDim2.new(0.5, -50, 0, 20)
AvatarImage.BackgroundColor3 = Theme.Background
AddCorner(AvatarImage, 50) -- Circular Avatar
local content, isReady = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
AvatarImage.Image = content

local UsernameLabel = Instance.new("TextLabel", ProfileCard)
UsernameLabel.Size = UDim2.new(1, 0, 0, 30)
UsernameLabel.Position = UDim2.new(0, 0, 0, 130)
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Text = LocalPlayer.Name
UsernameLabel.Font = Enum.Font.GothamBold
UsernameLabel.TextSize = 16
UsernameLabel.TextColor3 = Theme.TextPrimary

local ThreatLabel = Instance.new("TextLabel", ProfileCard)
ThreatLabel.Size = UDim2.new(0.9, 0, 0, 25)
ThreatLabel.Position = UDim2.new(0.05, 0, 0, 160)
ThreatLabel.BackgroundColor3 = Theme.Background
ThreatLabel.Font = Enum.Font.CodeBold
ThreatLabel.TextSize = 14
AddCorner(ThreatLabel, 4)

-- Threat Detection Logic
if LocalPlayer.Name == "city800" then
ThreatLabel.Text = "[ CLASS-X THREAT ]"
ThreatLabel.TextColor3 = Theme.Threat
local ThreatStroke = Instance.new("UIStroke", ThreatLabel)
ThreatStroke.Color = Theme.Threat
ThreatStroke.Thickness = 1
else
ThreatLabel.Text = "[ STANDARD USER ]"
ThreatLabel.TextColor3 = Theme.TextSecondary
end

-- Tab Container (Right Side)
local ContentArea = Instance.new("ScrollingFrame", MainHub)
ContentArea.Size = UDim2.new(1, -210, 1, -20)
ContentArea.Position = UDim2.new(0, 200, 0, 10)
ContentArea.BackgroundTransparency = 1
ContentArea.ScrollBarThickness = 4
ContentArea.ScrollBarImageColor3 = Theme.Accent

local ContentLayout = Instance.new("UIListLayout", ContentArea)
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- STREAMING_CHUNK: Designing the Toggle and Button System...
local function CreateToggle(name, callback)
local toggleFrame = Instance.new("Frame", ContentArea)
toggleFrame.Size = UDim2.new(1, -10, 0, 50)
toggleFrame.BackgroundColor3 = Theme.Surface
AddCorner(toggleFrame, 8)

local label = Instance.new("TextLabel", toggleFrame)
label.Size = UDim2.new(0.7, 0, 1, 0)
label.Position = UDim2.new(0, 15, 0, 0)
label.BackgroundTransparency = 1
label.Text = name
label.Font = Enum.Font.GothamMedium
label.TextSize = 15
label.TextColor3 = Theme.TextPrimary
label.TextXAlignment = Enum.TextXAlignment.Left

local switchBtn = Instance.new("TextButton", toggleFrame)
switchBtn.Size = UDim2.new(0, 50, 0, 26)
switchBtn.Position = UDim2.new(1, -65, 0.5, -13)
switchBtn.BackgroundColor3 = Theme.ToggleOff
switchBtn.Text = ""
AddCorner(switchBtn, 13)

local circle = Instance.new("Frame", switchBtn)
circle.Size = UDim2.new(0, 20, 0, 20)
circle.Position = UDim2.new(0, 3, 0.5, -10)
circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AddCorner(circle, 10)

local isOn = false
switchBtn.MouseButton1Click:Connect(function()
    isOn = not isOn
    local targetColor = isOn and Theme.Accent or Theme.ToggleOff
    local targetPos = isOn and UDim2.new(0, 27, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    
    TweenService:Create(switchBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
    TweenService:Create(circle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = targetPos}):Play()
    
    callback(isOn)
end)


end

local function CreateButton(name, callback)
local btn = Instance.new("TextButton", ContentArea)
btn.Size = UDim2.new(1, -10, 0, 45)
btn.BackgroundColor3 = Theme.Surface
btn.Text = name
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.TextColor3 = Theme.Accent
AddCorner(btn, 8)

btn.MouseButton1Click:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Outline}):Play()
    task.wait(0.1)
    TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Surface}):Play()
    callback()
end)


end

-- STREAMING_CHUNK: Populating Scripts and Modules...
CreateToggle("Enable Kill Aura", function(state)
if state then
print("[HUB] Kill Aura Activated")
else
print("[HUB] Kill Aura Deactivated")
end
end)

CreateToggle("Hitbox Expander", function(state)
if state then
print("[HUB] Hitboxes Expanded")
else
print("[HUB] Hitboxes Normalized")
end
end)

CreateButton("Execute Nameless Admin", function()
print("[HUB] Loading Nameless Admin...")
loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
end)

CreateButton("Execute M7 Admin", function()
print("[HUB] Loading M7 Admin...")
loadstring(game:HttpGet("https://mois7.xyz/loader"))()
end)

-- STREAMING_CHUNK: Implementing the Hacker Cutscene and Boot Sequence...
local function TypewriterEffect(label, text, speed)
for i = 1, #text do
label.Text = string.sub(text, 1, i)
task.wait(speed)
end
end

local function PlayIntroCutscene()
KeyFrame.Visible = false

local BlackScreen = Instance.new("Frame", gui)
BlackScreen.Size = UDim2.new(1, 0, 1, 0)
BlackScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BlackScreen.ZIndex = 100

local TerminalText = Instance.new("TextLabel", BlackScreen)
TerminalText.Size = UDim2.new(0.8, 0, 0.8, 0)
TerminalText.Position = UDim2.new(0.1, 0, 0.1, 0)
TerminalText.BackgroundTransparency = 1
TerminalText.Font = Enum.Font.Code
TerminalText.TextSize = 24
TerminalText.TextColor3 = Theme.Accent
TerminalText.TextXAlignment = Enum.TextXAlignment.Left
TerminalText.TextYAlignment = Enum.TextYAlignment.Top
TerminalText.Text = ""

local sequence = {
    "> ESTABLISHING SECURE CONNECTION...",
    "> BYPASSING BYFRON ANTICHEAT...",
    "> INJECTING DEPENDENCIES...",
    "> VERIFYING USER IDENTITY...",
    "> IDENTITY CONFIRMED: " .. LocalPlayer.Name,
    (LocalPlayer.Name == "city800" and "> WARNING: CLASS-X THREAT DETECTED." or "> ACCESS GRANTED."),
    "> LAUNCHING UNIFIED HUB V3..."
}

local currentText = ""
for _, line in ipairs(sequence) do
    currentText = currentText .. line .. "\n"
    TypewriterEffect(TerminalText, currentText, 0.02)
    task.wait(0.4)
end

task.wait(0.5)
TweenService:Create(BlackScreen, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
TweenService:Create(TerminalText, TweenInfo.new(1), {TextTransparency = 1}):Play()
task.wait(1)

BlackScreen:Destroy()
MainHub.Visible = true


end

-- Key Submission Logic
KeySubmit.MouseButton1Click:Connect(function()
if KeyInput.Text == KEY then
PlayIntroCutscene()
else
KeyInput.Text = ""
KeyInput.PlaceholderText = "ACCESS DENIED"
KeyInput.PlaceholderColor3 = Theme.Threat
task.wait(1.5)
KeyInput.PlaceholderText = "ENTER ACCESS KEY"
KeyInput.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
end
end)

print("Unified Hub V3 successfully loaded. Awaiting Key.")
