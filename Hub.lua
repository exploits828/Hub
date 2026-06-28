-- STREAMING_CHUNK: Initializing Core Services and Variables
-- ==============================================================================
-- ⚡ DWS HUB V6 (PREMIUM DASHBOARD EDITION)
-- MINIMIZABLE | TARGET AURA | QUANTUM GRABBER | PERSISTENT HITBOXES
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local startTime = os.time()

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

-- STREAMING_CHUNK: Building the Floating Minimize Button
-- ==============================================================================
-- 🔽 FLOATING OPEN BUTTON (Visible when minimized)
-- ==============================================================================
local OpenButton = Create("TextButton", {
Size = UDim2.new(0, 50, 0, 50),
Position = UDim2.new(0, 20, 0, 20),
BackgroundColor3 = Theme.Primary,
TextColor3 = Color3.new(1,1,1),
Text = "⚡",
Font = Enum.Font.GothamBold,
TextSize = 24,
Visible = false
}, UI)
Round(OpenButton, 25); Stroke(OpenButton, Color3.new(1,1,1), 1)

-- STREAMING_CHUNK: Building the Key System overlay
-- ==============================================================================
-- 🔐 PROFESSIONAL KEY SYSTEM
-- ==============================================================================
local KeyOverlay = Create("Frame", {Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 0.2}, UI)
local KeyCard = Create("Frame", {Size = UDim2.new(0, 450, 0, 260), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Theme.Card}, KeyOverlay)
Round(KeyCard, 12); Stroke(KeyCard, Theme.Primary, 1)

local ShieldIcon = Create("ImageLabel", {Size = UDim2.new(0, 40, 0, 40), Position = UDim2.new(0.5, -20, 0, 20), BackgroundTransparency = 1, Image = "rbxassetid://3926305014", ImageColor3 = Theme.Primary}, KeyCard)
Create("TextLabel", {Size = UDim2.new(1,0,0,30), Position = UDim2.new(0, 0, 0, 70), Text = "Key Verification System", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 18, BackgroundTransparency = 1}, KeyCard)
local KeyInput = Create("TextBox", {Size = UDim2.new(0.9, 0, 0, 45), Position = UDim2.new(0.05, 0, 0.45, 0), BackgroundColor3 = Theme.Bg, TextColor3 = Theme.Text, PlaceholderText = "Enter your verification key...", Font = Enum.Font.Gotham, TextSize = 14}, KeyCard)
Round(KeyInput, 8); Stroke(KeyInput, Theme.Muted, 1)

local GetLinkBtn = Create("TextButton", {Size = UDim2.new(0.43, 0, 0, 45), Position = UDim2.new(0.05, 0, 0.75, 0), BackgroundColor3 = Theme.Primary, TextColor3 = Color3.new(1,1,1), Text = "🔗 Get Link", Font = Enum.Font.GothamBold, TextSize = 14}, KeyCard)
Round(GetLinkBtn, 8)
local VerifyBtn = Create("TextButton", {Size = UDim2.new(0.43, 0, 0, 45), Position = UDim2.new(0.52, 0, 0.75, 0), BackgroundColor3 = Theme.Success, TextColor3 = Color3.new(1,1,1), Text = "✔️ Verify Key", Font = Enum.Font.GothamBold, TextSize = 14}, KeyCard)
Round(VerifyBtn, 8)

-- STREAMING_CHUNK: Constructing the Main Dashboard and Drag Logic
-- ==============================================================================
-- 💻 DASHBOARD UI
-- ==============================================================================
local MainHub = Create("Frame", {Size = UDim2.new(0, 800, 0, 500), AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Theme.Bg, Visible = false}, UI)
Round(MainHub, 16); Stroke(MainHub, Theme.ToggleOff, 1)

local MinimizeBtn = Create("TextButton", {Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -40, 0, 10), BackgroundTransparency = 1, Text = "-", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 24}, MainHub)

MinimizeBtn.MouseButton1Click:Connect(function()
MainHub.Visible = false
OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
MainHub.Visible = true
OpenButton.Visible = false
end)

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

-- STREAMING_CHUNK: Setting up the Icon-based Navigation Dock
-- ==============================================================================
-- 🧭 BOTTOM NAVIGATION DOCK (WITH ICONS)
-- ==============================================================================
local Dock = Create("Frame", {Size = UDim2.new(0, 400, 0, 50), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -15), BackgroundColor3 = Theme.Card}, MainHub)
Round(Dock, 25); Stroke(Dock, Theme.ToggleOff, 1)

local Tabs = {}
local function CreateNavBtn(iconId, name, pos)
local btn = Create("TextButton", {Size = UDim2.new(0, 80, 1, 0), Position = pos, BackgroundTransparency = 1, Text = ""}, Dock)
local icon = Create("ImageLabel", {Size = UDim2.new(0, 24, 0, 24), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1, Image = iconId, ImageColor3 = Theme.Muted}, btn)

local page = Create("ScrollingFrame", {Size = UDim2.new(1, -40, 1, -90), Position = UDim2.new(0, 20, 0, 20), BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 4}, MainHub)
Create("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}, page)
Tabs[name] = {Page = page, Icon = icon}

btn.MouseButton1Click:Connect(function()
	for _, t in pairs(Tabs) do 
		t.Page.Visible = false
		TweenService:Create(t.Icon, TweenInfo.new(0.2), {ImageColor3 = Theme.Muted}):Play()
	end
	page.Visible = true
	TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = Theme.Primary}):Play()
end)
return page


end

-- Using Standard UI Asset IDs for Icons
local HomeTab = CreateNavBtn("rbxassetid://3926305904", "Home", UDim2.new(0, 0, 0, 0))
local CombatTab = CreateNavBtn("rbxassetid://7733674079", "Combat", UDim2.new(0.2, 0, 0, 0))
local UtilityTab = CreateNavBtn("rbxassetid://3926307971", "Utility", UDim2.new(0.4, 0, 0, 0))
local AdminTab = CreateNavBtn("rbxassetid://3926305014", "Admins", UDim2.new(0.6, 0, 0, 0))
local VegaTab = CreateNavBtn("rbxassetid://3926305655", "VegaX", UDim2.new(0.8, 0, 0, 0))

HomeTab.Visible = true
Tabs["Home"].Icon.ImageColor3 = Theme.Primary

-- STREAMING_CHUNK: Developing the Home Tab and Runtime Tracker
-- ==============================================================================
-- 🏠 HOME TAB (AVATAR, SERVER & RUNTIME)
-- ==============================================================================
local ServerCard = Create("Frame", {Size = UDim2.new(0, 300, 0, 150), BackgroundColor3 = Theme.Card}, HomeTab)
Round(ServerCard, 12); Stroke(ServerCard, Theme.Primary, 1)
Create("TextLabel", {Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1, Text = "Session Details", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left}, ServerCard)
Create("TextLabel", {Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 45), BackgroundTransparency = 1, Text = "Players: " .. #Players:GetPlayers(), TextColor3 = Theme.Muted, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left}, ServerCard)

local RuntimeLabel = Create("TextLabel", {Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 75), BackgroundTransparency = 1, Text = "Runtime: 00:00:00", TextColor3 = Theme.Muted, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left}, ServerCard)

RunService.Heartbeat:Connect(function()
local diff = os.time() - startTime
local h = math.floor(diff / 3600)
local m = math.floor((diff % 3600) / 60)
local s = diff % 60
RuntimeLabel.Text = string.format("Runtime: %02d:%02d:%02d", h, m, s)
end)

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

-- STREAMING_CHUNK: Generating Toggle Switch Elements
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

-- STREAMING_CHUNK: Implementing Combat Scripts (Hitbox Fix & Target Aura)
-- ==============================================================================
-- ⚔️ COMBAT TAB LOGIC
-- ==============================================================================

-- 1. Persistent Hitbox Expander (Fixed to stay on after respawn)
local HitboxEnabled = false
CreateToggle(CombatTab, "Hitbox Expander (Persistent)", function(state)
HitboxEnabled = state
if not state then
-- Revert all sizes when turned off
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
local hrp = p.Character.HumanoidRootPart
hrp.Size = Vector3.new(2, 2, 1)
hrp.Transparency = 1
end
end
end
end)

RunService.Heartbeat:Connect(function()
if not HitboxEnabled then return end
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
local hrp = p.Character.HumanoidRootPart
hrp.Size = Vector3.new(10, 10, 10)
hrp.Transparency = 0.8
hrp.BrickColor = BrickColor.new("Royal blue")
hrp.CanCollide = false
end
end
end)

-- 2. Target Kill Aura Logic
local TargetList = {}
local AuraActive = false
local Ignorelist = OverlapParams.new()
Ignorelist.FilterType = Enum.RaycastFilterType.Include

local AuraContainer = Create("Frame", {Size = UDim2.new(1, 0, 0, 200), BackgroundColor3 = Theme.Bg, BackgroundTransparency = 1}, CombatTab)
Create("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, AuraContainer)

CreateToggle(AuraContainer, "🎯 Target Kill Aura", function(state) AuraActive = state end)

local PlayerScroll = Create("ScrollingFrame", {Size = UDim2.new(1, 0, 0, 130), BackgroundColor3 = Theme.Card, ScrollBarThickness = 4}, AuraContainer)
Round(PlayerScroll, 8); Stroke(PlayerScroll, Theme.Primary, 1)
Create("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, PlayerScroll)

local function UpdatePlayerList()
for _, c in ipairs(PlayerScroll:GetChildren()) do
if c:IsA("TextButton") then c:Destroy() end
end

for _, p in ipairs(Players:GetPlayers()) do
	if p ~= LocalPlayer then
		local btn = Create("TextButton", {Size = UDim2.new(1, -10, 0, 30), BackgroundColor3 = Theme.Bg, TextColor3 = Theme.Text, Text = p.Name, Font = Enum.Font.Gotham}, PlayerScroll)
		Round(btn, 6); Stroke(btn, Theme.Muted, 1)
		
		local isTarget = table.find(TargetList, p)
		if isTarget then btn.BackgroundColor3 = Theme.Primary end
		
		btn.MouseButton1Click:Connect(function()
			local idx = table.find(TargetList, p)
			if idx then
				table.remove(TargetList, idx)
				btn.BackgroundColor3 = Theme.Bg
			else
				table.insert(TargetList, p)
				btn.BackgroundColor3 = Theme.Primary
			end
		end)
	end
end


end
UpdatePlayerList()
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

-- Aura Heartbeat & Rendering
local function GetTouchInterest(tool)
for _, obj in ipairs(tool:GetDescendants()) do
if obj:IsA("TouchTransmitter") and obj.Parent:IsA("BasePart") then return obj.Parent end
end
end

RunService.Heartbeat:Connect(function()
if not AuraActive or #TargetList == 0 or not LocalPlayer.Character then return end
local char = LocalPlayer.Character

local validChars = {}
for _, p in ipairs(TargetList) do if p.Character then table.insert(validChars, p.Character) end end
Ignorelist.FilterDescendantsInstances = validChars

for _, tool in ipairs(char:GetChildren()) do
	if tool:IsA("Tool") then
		local touch = GetTouchInterest(tool)
		if touch then
			local parts = workspace:GetPartBoundsInBox(touch.CFrame, touch.Size + Vector3.new(30,30,30), Ignorelist)
			for _, p in ipairs(parts) do
				if p.Parent:FindFirstChild("Humanoid") then
					firetouchinterest(touch, p, 1)
					firetouchinterest(touch, p, 0)
				end
			end
		end
	end
end


end)

-- STREAMING_CHUNK: Implementing Quantum Utility Scripts
-- ==============================================================================
-- 🛠️ UTILITY TAB
-- ==============================================================================

-- Quantum Instant Parallel Tool Grabber (Specific 4 Weapons)
local QTGActive = false
local QTG_Loops = {}
local toolToBase = {["Energy Sword"] = "Stone", ["Staff"] = "Magic", ["Axe"] = "Storm", ["Fist"] = "Robotic"}

local function hasTool(toolName)
local function scan(c)
if not c then return false end
for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") and t.Name == toolName then return true end end
end
return scan(LocalPlayer.Backpack) or scan(LocalPlayer.Character)
end

local function startToolLoop(toolName)
if QTG_Loops[toolName] then return end
QTG_Loops[toolName] = true
task.spawn(function()
while QTG_Loops[toolName] and QTGActive do
if hasTool(toolName) then QTG_Loops[toolName] = nil break end

		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root then
			for _, d in ipairs(workspace:GetDescendants()) do
				if d:IsA("TouchTransmitter") and d.Parent and d.Parent.Parent and d.Parent.Parent.Name:find("GearGiver1") then
					local baseName = d.Parent.Parent.Parent and d.Parent.Parent.Parent.Name
					if baseName == toolToBase[toolName] then
						if (d.Parent.Position - root.Position).Magnitude < 1000 then
							for i = 1, 8 do
								firetouchinterest(root, d.Parent, 0)
								firetouchinterest(root, d.Parent, 1)
							end
						end
					end
				end
			end
		end
		task.wait()
	end
end)


end

CreateToggle(UtilityTab, "Quantum Tool Grabber", function(state)
QTGActive = state
if state then
for toolName in pairs(toolToBase) do startToolLoop(toolName) end
else
for k, _ in pairs(QTG_Loops) do QTG_Loops[k] = false end
end
end)

-- Re-trigger Grabber on Respawn if enabled
LocalPlayer.CharacterAdded:Connect(function()
if QTGActive then
for toolName in pairs(toolToBase) do startToolLoop(toolName) end
end
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

-- STREAMING_CHUNK: Setting up Admin and Engine Modules
-- ==============================================================================
-- 🛡️ ADMINS TAB
-- ==============================================================================
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

-- ===========
