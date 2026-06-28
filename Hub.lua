-- STREAMING_CHUNK: Initializing Core Services and Environment
-- ==============================================================================
-- ⚡ DWS HUB V7 (PREMIUM DASHBOARD EDITION)
-- ==============================================================================

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

-- Helper functions
local function Create(class, props, parent)
local obj = Instance.new(class)
for i, v in pairs(props) do obj[i] = v end
if parent then obj.Parent = parent end
return obj
end
local function Round(obj, rad) Create("UICorner", {CornerRadius = UDim.new(0, rad)}, obj) end
local function Stroke(obj, color, thick) Create("UIStroke", {Color = color, Thickness = thick, Transparency = 0.2}, obj) end

-- STREAMING_CHUNK: Developing the Floating Minimize System
-- ==============================================================================
local OpenButton = Create("TextButton", {
Size = UDim2.new(0, 70, 0, 70),
Position = UDim2.new(0, 40, 0, 40),
BackgroundColor3 = Theme.Primary,
Text = "⚡",
Font = Enum.Font.GothamBold,
TextSize = 30,
TextColor3 = Color3.new(1,1,1),
Visible = false
}, UI)
Round(OpenButton, 35); Stroke(OpenButton, Color3.new(1,1,1), 3)

-- STREAMING_CHUNK: Constructing the Main Hub Architecture
-- ==============================================================================
local MainHub = Create("Frame", {
Size = UDim2.new(0, 800, 0, 500),
AnchorPoint = Vector2.new(0.5,0.5),
Position = UDim2.new(0.5, 0, 0.5, 0),
BackgroundColor3 = Theme.Bg,
Active = true,
Draggable = true
}, UI)
Round(MainHub, 16); Stroke(MainHub, Theme.ToggleOff, 2)

local MinimizeBtn = Create("TextButton", {
Size = UDim2.new(0, 60, 0, 60),
Position = UDim2.new(1, -70, 0, 10),
BackgroundColor3 = Theme.Danger,
Text = "-",
TextColor3 = Color3.new(1,1,1),
Font = Enum.Font.GothamBold,
TextSize = 30
}, MainHub)
Round(MinimizeBtn, 30)
MinimizeBtn.MouseButton1Click:Connect(function() MainHub.Visible = false; OpenButton.Visible = true end)
OpenButton.MouseButton1Click:Connect(function() MainHub.Visible = true; OpenButton.Visible = false end)

-- STREAMING_CHUNK: Setting up Navigation and Tab System
-- ==============================================================================
local Dock = Create("Frame", {Size = UDim2.new(0, 500, 0, 70), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -20), BackgroundColor3 = Theme.Card}, MainHub)
Round(Dock, 35); Stroke(Dock, Theme.ToggleOff, 1)

local Tabs = {}
local function CreateTab(name, index)
local btn = Create("TextButton", {Size = UDim2.new(0, 90, 0, 50), Position = UDim2.new(0.02 + (index * 0.195), 0, 0.5, -25), BackgroundTransparency = 1, Text = name, TextColor3 = Theme.Muted, Font = Enum.Font.GothamBold}, Dock)
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

-- STREAMING_CHUNK: Home Tab Logic (Runtime Tracker)
-- ==============================================================================
local RuntimeLabel = Create("TextLabel", {Size = UDim2.new(1,0,0,50), BackgroundTransparency = 1, Text = "Runtime: 00:00:00", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 20}, HomeTab)
RunService.Heartbeat:Connect(function()
local diff = os.time() - startTime
RuntimeLabel.Text = string.format("Runtime: %02d:%02d:%02d", math.floor(diff/3600), math.floor((diff%3600)/60), diff%60)
end)

-- STREAMING_CHUNK: Persistent Hitbox with 3D Outline
-- ==============================================================================
local HitboxEnabled = false
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

CreateToggle(CombatTab, "Persistent Hitbox (3D Outline)", function(s)
HitboxEnabled = s
if not s then
for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("DWS_Highlight") then p.Character.DWS_Highlight:Destroy() end end
end
end)

RunService.Heartbeat:Connect(function()
if not HitboxEnabled then return end
for _, p in pairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character then
if not p.Character:FindFirstChild("DWS_Highlight") then
local h = Instance.new("Highlight", p.Character)
h.Name = "DWS_Highlight"
h.FillColor = Color3.fromRGB(45, 120, 255); h.FillTransparency = 0.5; h.OutlineColor = Color3.new(0,0,0); h.OutlineTransparency = 0
end
end
end
end)

-- STREAMING_CHUNK: Target Kill Aura with Selection Menu
-- ==============================================================================
local TargetList = {}
local AuraActive = false
CreateToggle(CombatTab, "🎯 Target Kill Aura", function(s) AuraActive = s end)
local AuraMenu = Create("ScrollingFrame", {Size = UDim2.new(1, 0, 0, 150), BackgroundColor3 = Theme.Card, Visible = true}, CombatTab)
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
Players.PlayerAdded:Connect(UpdateAuraMenu)
Players.PlayerRemoving:Connect(UpdateAuraMenu)

-- STREAMING_CHUNK: Quantum Tool Grabber
-- ==============================================================================
local QTGActive = false
local toolList = {"Energy Sword", "Staff", "Axe", "Fist"}
CreateToggle(UtilityTab, "Quantum Tool Grabber", function(s) QTGActive = s end)

task.spawn(function()
while true do
if QTGActive and LocalPlayer.Character then
for _, d in pairs(workspace:GetDescendants()) do
if d:IsA("TouchTransmitter") and d.Parent and d.Parent.Parent and d.Parent.Parent.Name:find("GearGiver1") then
for _, tName in pairs(toolList) do
if not LocalPlayer.Backpack:FindFirstChild(tName) and not LocalPlayer.Character:FindFirstChild(tName) then
firetouchinterest(LocalPlayer.Character.HumanoidRootPart, d.Parent, 0)
firetouchinterest(LocalPlayer.Character.HumanoidRootPart, d.Parent, 1)
end
end
end
end
end
task.wait(1)
end
end)

-- STREAMING_CHUNK: Admin and Vega Integration
-- ==============================================================================
Create("TextButton", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Primary, Text = "Execute Nameless Admin", Parent = AdminTab}).MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))() end)
Create("TextButton", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Primary, Text = "Execute M7 Admin", Parent = AdminTab}).MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://mois7.xyz/loader"))() end)

CreateToggle(VegaTab, "Vega X: No Cooldown", function(s)
if s then
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
local args = {...}
if getnamecallmethod() == "FireServer" and tostring(self) == "Cooldown" then return end
return old(self, ...)
end)
end
end)

print("⚡ Unified Hub V7 Loaded")
