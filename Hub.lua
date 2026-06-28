-- STREAMING_CHUNK: Initializing Professional Theme Engine
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Theme = {
Background = Color3.fromRGB(15, 15, 20),
Surface = Color3.fromRGB(22, 22, 28),
Border = Color3.fromRGB(45, 45, 55),
Text = Color3.fromRGB(240, 240, 245),
DimText = Color3.fromRGB(150, 150, 160),
Primary = Color3.fromRGB(45, 100, 255),
Success = Color3.fromRGB(45, 180, 80),
Threat = Color3.fromRGB(255, 60, 60)
}

-- Destroy old UI
if CoreGui:FindFirstChild("ProHub") then CoreGui:FindFirstChild("ProHub"):Destroy() end
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "ProHub"
gui.ResetOnSpawn = false

-- Helper Functions
local function Create(class, props, parent)
local obj = Instance.new(class)
for i, v in pairs(props) do obj[i] = v end
obj.Parent = parent
return obj
end

local function AddCorner(parent, radius)
Create("UICorner", {CornerRadius = UDim.new(0, radius)}, parent)
end

-- STREAMING_CHUNK: Building the Key Verification UI (images (4).jpeg style)
local KeyFrame = Create("Frame", {
Size = UDim2.new(0, 450, 0, 280),
Position = UDim2.new(0.5, -225, 0.5, -140),
BackgroundColor3 = Theme.Background,
BorderSizePixel = 0,
Visible = true,
Parent = gui
})
AddCorner(KeyFrame, 12)
Create("UIStroke", {Color = Theme.Border, Thickness = 2}, KeyFrame)

Create("TextLabel", {
Size = UDim2.new(1, 0, 0, 50),
BackgroundTransparency = 1,
Text = "🛡️ Key Verification System",
TextColor3 = Theme.Text,
Font = Enum.Font.GothamBold,
TextSize = 18,
Parent = KeyFrame
})

local KeyInput = Create("TextBox", {
Size = UDim2.new(0.9, 0, 0, 50),
Position = UDim2.new(0.05, 0, 0.3, 0),
BackgroundColor3 = Theme.Surface,
TextColor3 = Theme.Text,
PlaceholderText = "Enter your verification key",
PlaceholderColor3 = Theme.DimText,
Font = Enum.Font.Gotham,
TextSize = 16,
Parent = KeyFrame
})
AddCorner(KeyInput, 8)
Create("UIStroke", {Color = Theme.Border}, KeyInput)

local BtnContainer = Create("Frame", {
Size = UDim2.new(0.9, 0, 0, 50),
Position = UDim2.new(0.05, 0, 0.65, 0),
BackgroundTransparency = 1,
Parent = KeyFrame
})

local GetLink = Create("TextButton", {
Size = UDim2.new(0.48, 0, 1, 0),
BackgroundColor3 = Theme.Primary,
Text = "Get Link",
TextColor3 = Color3.new(1, 1, 1),
Font = Enum.Font.GothamBold,
Parent = BtnContainer
})
AddCorner(GetLink, 8)

local VerifyBtn = Create("TextButton", {
Size = UDim2.new(0.48, 0, 1, 0),
Position = UDim2.new(0.52, 0, 0, 0),
BackgroundColor3 = Theme.Success,
Text = "Verify Key",
TextColor3 = Color3.new(1, 1, 1),
Font = Enum.Font.GothamBold,
Parent = BtnContainer
})
AddCorner(VerifyBtn, 8)

-- STREAMING_CHUNK: Designing the Main Dashboard (b6d4f9a449bd4a36003ac5c757d4a8aa976dd3b5_2.jpeg style)
local MainHub = Create("Frame", {
Size = UDim2.new(0, 900, 0, 500),
Position = UDim2.new(0.5, -450, 0.5, -250),
BackgroundColor3 = Theme.Background,
Visible = false,
Parent = gui
})
AddCorner(MainHub, 16)

-- Server Info Card
local ServerCard = Create("Frame", {
Size = UDim2.new(0, 300, 0, 200),
Position = UDim2.new(0.02, 0, 0.05, 0),
BackgroundColor3 = Theme.Surface,
Parent = MainHub
})
AddCorner(ServerCard, 12)
Create("TextLabel", {
Size = UDim2.new(1, 0, 0, 40),
Text = "   Server Status",
TextColor3 = Theme.Text,
Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
BackgroundTransparency = 1,
Parent = ServerCard
})

-- Avatar & Threat Badge Logic
local UserCard = Create("Frame", {
Size = UDim2.new(0, 300, 0, 80),
Position = UDim2.new(0.02, 0, 0.45, 0),
BackgroundColor3 = Theme.Surface,
Parent = MainHub
})
AddCorner(UserCard, 12)

Create("ImageLabel", {
Size = UDim2.new(0, 60, 0, 60),
Position = UDim2.new(0.05, 0, 0.1, 0),
Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420),
Parent = UserCard
})

local UserNameLabel = Create("TextLabel", {
Size = UDim2.new(0.6, 0, 0.5, 0),
Position = UDim2.new(0.3, 0, 0.25, 0),
Text = LocalPlayer.Name,
TextColor3 = Theme.Text,
Font = Enum.Font.GothamBold,
BackgroundTransparency = 1,
Parent = UserCard
})

-- Threat Logic
if LocalPlayer.Name == "city800" then
Create("TextLabel", {
Size = UDim2.new(0.4, 0, 0.3, 0),
Position = UDim2.new(0.3, 0, 0.6, 0),
Text = "⚠️ THREAT",
TextColor3 = Theme.Threat,
Font = Enum.Font.GothamBold,
BackgroundTransparency = 1,
Parent = UserCard
})
end

-- Bottom Navigation Dock
local Dock = Create("Frame", {
Size = UDim2.new(0.5, 0, 0, 60),
Position = UDim2.new(0.25, 0, 0.85, 0),
BackgroundColor3 = Theme.Surface,
Parent = MainHub
})
AddCorner(Dock, 30)

-- Logic for authentication
VerifyBtn.MouseButton1Click:Connect(function()
KeyFrame.Visible = false
MainHub.Visible = true
end)
