-- DWS HUB v4.0 - Premium Dashboard Architecture
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local UI = Instance.new("ScreenGui", game:GetService("CoreGui"))
UI.Name = "DWS_Hub_v4"

-- Factory for modern UI elements
local function create(c,p,props)
    local obj = Instance.new(c,p)
    for i,v in pairs(props) do obj[i] = v end
    return obj
end

-- Main Dashboard
local Main = create("Frame", UI, {Size = UDim2.new(0, 700, 0, 450), Position = UDim2.new(0.5, -350, 0.5, -225), BackgroundColor3 = Color3.fromRGB(15,15,15), Visible = true})
create("UICorner", Main, {CornerRadius = UDim.new(0, 16)})
create("UIStroke", Main, {Color = Color3.fromRGB(40,40,40), Thickness = 2})

-- Bottom Navigation
local Nav = create("Frame", Main, {Size = UDim2.new(0, 300, 0, 50), Position = UDim2.new(0.5, -150, 1, -60), BackgroundColor3 = Color3.fromRGB(20,20,20)})
create("UICorner", Nav, {CornerRadius = UDim.new(0, 12)})

local function createTabBtn(name, icon, pos)
    local btn = create("TextButton", Nav, {Size = UDim2.new(0, 50, 0, 50), Position = pos, BackgroundTransparency = 1, Text = icon, TextSize = 20, Font = Enum.Font.Code, TextColor3 = Color3.new(1,1,1)})
    btn.MouseButton1Click:Connect(function() print("Switched to "..name) end)
end

createTabBtn("Home", "🏠", UDim2.new(0, 20, 0, 0))
createTabBtn("Combat", "⚔️", UDim2.new(0, 90, 0, 0))
createTabBtn("Utility", "⚙️", UDim2.new(0, 160, 0, 0))
createTabBtn("Settings", "🛠️", UDim2.new(0, 230, 0, 0))

-- Example Dashboard Card (The "Server" card style from your image)
local Card = create("Frame", Main, {Size = UDim2.new(0, 200, 0, 120), Position = UDim2.new(0, 20, 0, 20), BackgroundColor3 = Color3.fromRGB(25,25,25)})
create("UICorner", Card, {CornerRadius = UDim.new(0, 12)})
create("TextLabel", Card, {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "Server Status", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold})

local PlayersLabel = create("TextLabel", Card, {Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0,0,0,40), BackgroundTransparency = 1, Text = "Players: " .. #Players:GetPlayers(), TextColor3 = Color3.new(0.6,0.6,0.6), Font = Enum.Font.Gotham})

-- Admin Action Cards
local AdminCard = create("Frame", Main, {Size = UDim2.new(0, 200, 0, 100), Position = UDim2.new(0, 240, 0, 20), BackgroundColor3 = Color3.fromRGB(25,25,25)})
create("UICorner", AdminCard, {CornerRadius = UDim.new(0, 12)})
create("TextLabel", AdminCard, {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "Admin Tools", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold})

create("TextButton", AdminCard, {Size = UDim2.new(0, 100, 0, 30), Position = UDim2.new(0.5, -50, 0, 40), BackgroundColor3 = Color3.fromRGB(0, 100, 255), Text = "Nameless", TextColor3 = Color3.new(1,1,1)}).MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
end)

print("⚡ DWS HUB v4.0 - Dashboard Style Loaded")
