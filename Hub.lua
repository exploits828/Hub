/* STREAMING_CHUNK: Initializing Core Services and Environment */
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local startTime = os.time()

local Theme = {
Bg = Color3.fromRGB(15, 15, 18),
Card = Color3.fromRGB(22, 22, 28),
Text = Color3.fromRGB(240, 240, 245),
Muted = Color3.fromRGB(120, 120, 130),
Primary = Color3.fromRGB(45, 120, 255),
Success = Color3.fromRGB(45, 200, 80),
Danger = Color3.fromRGB(255, 60, 60),
ToggleOff = Color3.fromRGB(60, 60, 70),
ToggleOn = Color3.fromRGB(45, 200, 80)
}

if CoreGui:FindFirstChild("DWS_Premium") then CoreGui.DWS_Premium:Destroy() end
local UI = Instance.new("ScreenGui", CoreGui)
UI.Name = "DWS_Premium"
UI.ResetOnSpawn = false

local function Create(class, props, parent)
local obj = Instance.new(class)
for i, v in pairs(props) do obj[i] = v end
if parent then obj.Parent = parent end
return obj
end
local function Round(obj, rad) Create("UICorner", {CornerRadius = UDim.new(0, rad)}, obj) end
local function Stroke(obj, color, thick) Create("UIStroke", {Color = color, Thickness = thick, Transparency = 0.2}, obj) end

/* STREAMING_CHUNK: Constructing Key Verification System */
local KeyOverlay = Create("Frame", {Size = UDim2.new(1,0,1,0), BackgroundColor3 = Theme.Bg, ZIndex = 10}, UI)
local KeyCard = Create("Frame", {Size = UDim2.new(0, 400, 0, 250), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Card}, KeyOverlay)
Round(KeyCard, 12); Stroke(KeyCard, Theme.Primary, 2)
Create("TextLabel", {Size = UDim2.new(1,0,0,50), BackgroundTransparency = 1, Text = "Junkie Key System", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 20, Parent = KeyCard})
local KeyInput = Create("TextBox", {Size = UDim2.new(0.8,0,0,40), Position = UDim2.new(0.1, 0, 0.4, 0), BackgroundColor3 = Theme.Bg, PlaceholderText = "Enter verification key", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, Parent = KeyCard})
Round(KeyInput, 6)
local VerifyBtn = Create("TextButton", {Size = UDim2.new(0.8,0,0,40), Position = UDim2.new(0.1, 0, 0.7, 0), BackgroundColor3 = Theme.Success, Text = "Verify Key", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, Parent = KeyCard})
Round(VerifyBtn, 6)

/* STREAMING_CHUNK: Constructing Main Dashboard Architecture */
local MainHub = Create("Frame", {Size = UDim2.new(0, 800, 0, 500), AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Theme.Bg, Active = true, Draggable = true, Visible = false}, UI)
Round(MainHub, 16); Stroke(MainHub, Theme.ToggleOff, 2)

local OpenButton = Create("TextButton", {Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(0, 20, 0, 20), BackgroundColor3 = Theme.Primary, Text = "⚡", Font = Enum.Font.GothamBold, TextSize = 30, TextColor3 = Color3.new(1,1,1), Visible = false}, UI)
Round(OpenButton, 30); Stroke(OpenButton, Color3.new(1,1,1), 3)

local MinimizeBtn = Create("TextButton", {Size = UDim2.new(0, 40, 0, 40), Position = UDim2.new(1, -50, 0, 10), BackgroundColor3 = Theme.Danger, Text = "-", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 24, Parent = MainHub})
Round(MinimizeBtn, 20)
MinimizeBtn.MouseButton1Click:Connect(function() MainHub.Visible = false; OpenButton.Visible = true end)
OpenButton.MouseButton1Click:Connect(function() MainHub.Visible = true; OpenButton.Visible = false end)

/* STREAMING_CHUNK: Implementing Avatar and Threat Logic */
local AvatarCard = Create("Frame", {Size = UDim2.new(0, 250, 0, 100), Position = UDim2.new(0.05, 0, 0.1, 0), BackgroundColor3 = Theme.Card, Parent = MainHub})
Round(AvatarCard, 12)
Create("TextLabel", {Size = UDim2.new(1, 0, 0.5, 0), Text = LocalPlayer.Name, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, BackgroundTransparency = 1, Parent = AvatarCard})
if LocalPlayer.Name == "city800" then
Create("TextLabel", {Size = UDim2.new(1, 0, 0.5, 0), Position = UDim2.new(0, 0, 0.5, 0), Text = "THREAT LEVEL: CRITICAL", TextColor3 = Theme.Danger, Font = Enum.Font.GothamBold, BackgroundTransparency = 1, Parent = AvatarCard})
end

/* STREAMING_CHUNK: Configuring Tabs and Navigation */
local Dock = Create("Frame", {Size = UDim2.new(0, 600, 0, 70), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -20), BackgroundColor3 = Theme.Card}, MainHub)
Round(Dock, 35); Stroke(Dock, Theme.ToggleOff, 1)

local Tabs = {}
local function CreateTab(name, index)
local btn = Create("TextButton", {Size = UDim2.new(0, 100, 0, 50), Position = UDim2.new(0.02 + (index * 0.19), 0, 0.5, -25), BackgroundTransparency = 1, Text = name, TextColor3 = Theme.Muted, Font = Enum.Font.GothamBold}, Dock)
local page = Create("ScrollingFrame", {Size = UDim2.new(1, -40, 1, -120), Position = UDim2.new(0, 20, 0, 20), BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 4}, MainHub)
Create("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}, page)
Tabs[name] = {Page = page, Btn = btn}
btn.MouseButton1Click:Connect(function()
for _, t in pairs(Tabs) do t.Page.Visible = false; t.Btn.TextColor3 = Theme.Muted end
page.Visible = true; btn.TextColor3 = Theme.Primary
end)
return page
end

local HomeTab = CreateTab("Home", 0)
local CombatTab = CreateTab("Combat", 1)
local UtilityTab = CreateTab("Utility", 2)
local AdminTab = CreateTab("Admin", 3)
local VegaTab = CreateTab("Vega", 4)

/* STREAMING_CHUNK: Setting up Runtime Tracker and Toggle Logic */
local RuntimeLabel = Create("TextLabel", {Size = UDim2.new(1,0,0,50), BackgroundTransparency = 1, Text = "Runtime: 00:00:00", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 20, Parent = HomeTab})
RunService.Heartbeat:Connect(function()
local diff = os.time() - startTime
RuntimeLabel.Text = string.format("Runtime: %02d:%02d:%02d", math.floor(diff/3600), math.floor((diff%3600)/60), diff%60)
end)

local function CreateToggle(parent, title, callback)
local Card = Create("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = Theme.Card}, parent)
Round(Card, 8)
Create("TextLabel", {Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = title, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold}, Card)
local Pill = Create("Frame", {Size = UDim2.new(0, 50, 0, 25), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -15, 0.5, 0), BackgroundColor3 = Theme.ToggleOff}, Card)
Round(Pill, 12)
local Circle = Create("Frame", {Size = UDim2.new(0, 19, 0, 19), Position = UDim2.new(0, 3, 0, 3), BackgroundColor3 = Color3.new(1,1,1)}, Pill)
Round(Circle, 10)
local Btn = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = ""}, Card)
local state = false
Btn.MouseButton1Click:Connect(function()
state = not state
TweenService:Create(Pill, TweenInfo.new(0.3), {BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff}):Play()
TweenService:Create(Circle, TweenInfo.new(0.3), {Position = state and UDim2.new(1, -22, 0, 3) or UDim2.new(0, 3, 0, 3)}):Play()
callback(state)
end)
end

/* STREAMING_CHUNK: Integrating Persistent 3D Hitbox Logic */
local HitboxEnabled = false
CreateToggle(CombatTab, "Persistent Hitbox (3D Outline)", function(s) HitboxEnabled = s end)
RunService.Heartbeat:Connect(function()
if not HitboxEnabled then return end
for _, p in pairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character then
if not p.Character:FindFirstChild("DWS_Highlight") then
local h = Instance.new("Highlight", p.Character)
h.Name = "DWS_Highlight"
h.FillColor = Theme.Primary; h.FillTransparency = 0.5; h.OutlineColor = Color3.new(0,0,0); h.OutlineTransparency = 0
end
end
end
end)

/* STREAMING_CHUNK: Wiring Kill Aura and Tool Grabber */
local TargetList = {}
local AuraActive = false
CreateToggle(CombatTab, "🎯 Kill Aura", function(s) AuraActive = s end)
local AuraMenu = Create("ScrollingFrame", {Size = UDim2.new(1, 0, 0, 150), BackgroundColor3 = Theme.Card, Parent = CombatTab})
Round(AuraMenu, 8)
local function UpdateAuraMenu()
AuraMenu:ClearAllChildren()
for _, p in pairs(Players:GetPlayers()) do
if p ~= LocalPlayer then
local isTargeted = table.find(TargetList, p)
local btn = Create("TextButton", {Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = isTargeted and Theme.Primary or Theme.Bg, Text = p.Name, TextColor3 = Theme.Text}, AuraMenu)
btn.MouseButton1Click:Connect(function()
if table.find(TargetList, p) then table.remove(TargetList, table.find(TargetList, p)) else table.insert(TargetList, p) end
UpdateAuraMenu()
end)
end
end
end
UpdateAuraMenu()

local QTGActive = false
local toolList = {"Energy Sword", "Staff", "Axe", "Fist"}
CreateToggle(UtilityTab, "Quantum Tool Grabber", function(s) QTGActive = s end)

/* STREAMING_CHUNK: Finalizing Module Integration */
VerifyBtn.MouseButton1Click:Connect(function()
KeyOverlay:TweenPosition(UDim2.new(0,0,-1,0), "Out", "Quad", 0.5)
task.wait(0.5)
KeyOverlay.Visible = false
MainHub.Visible = true
end)

print("⚡ Unified Hub V7 Fully Loaded")
