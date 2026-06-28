-- Unified Hub V8 - Production Ready
-- Key: pvpOGS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- 1. Initialize UI Container
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "UnifiedHubV8"
gui.ResetOnSpawn = false

-- 2. Styling Config
local Theme = {
    Main = Color3.fromRGB(20, 20, 25),
    Accent = Color3.fromRGB(0, 100, 255),
    Text = Color3.fromRGB(255, 255, 255)
}

-- 3. Key System Overlay (Styled for Compatibility)
local KeyFrame = Instance.new("Frame", gui)
KeyFrame.Size = UDim2.new(0, 320, 0, 180)
KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
KeyFrame.BackgroundColor3 = Theme.Main
KeyFrame.BorderSizePixel = 1
KeyFrame.BorderColor3 = Theme.Accent
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 10)

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Size = UDim2.new(0.8, 0, 0, 40)
KeyBox.Position = UDim2.new(0.1, 0, 0.3, 0)
KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyBox.PlaceholderText = "Enter Key..."
KeyBox.Text = ""
KeyBox.TextColor3 = Theme.Text
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 16
KeyBox.BackgroundTransparency = 0
KeyBox.BorderSizePixel = 0

local KeyBtn = Instance.new("TextButton", KeyFrame)
KeyBtn.Size = UDim2.new(0.8, 0, 0, 40)
KeyBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
KeyBtn.Text = "AUTHENTICATE"
KeyBtn.BackgroundColor3 = Theme.Accent
KeyBtn.TextColor3 = Theme.Text
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.TextSize = 16
KeyBtn.BackgroundTransparency = 0
KeyBtn.BorderSizePixel = 0

-- 4. Main Dashboard
local MainFrame = Instance.new("Frame", gui)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Theme.Main
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- 5. Minimize Button (Hidden until Auth)
local MinBtn = Instance.new("TextButton", gui)
MinBtn.Size = UDim2.new(0, 50, 0, 50)
MinBtn.Position = UDim2.new(0.9, 0, 0.1, 0)
MinBtn.Text = "⚡"
MinBtn.BackgroundColor3 = Theme.Accent
MinBtn.TextColor3 = Theme.Text
MinBtn.Visible = false
MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- 6. Persistent 3D Hitbox Logic (Safe Check)
local function ApplyHitbox(char)
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp and not hrp:FindFirstChild("V8Highlight") then
            local hl = Instance.new("Highlight", hrp)
            hl.Name = "V8Highlight"
            hl.FillColor = Color3.fromRGB(0, 100, 255)
            hl.OutlineColor = Color3.fromRGB(0, 0, 0)
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
        end
    end
end

-- 7. Quantum Tool Grabber
local allowed = {["Energy Sword"]=true, ["Staff"]=true, ["Axe"]=true, ["Fist"]=true}
local function StartGrabber()
    task.spawn(function()
        while true do
            if lp.Backpack then
                for _, tool in pairs(lp.Backpack:GetChildren()) do
                    if allowed[tool.Name] then tool.Parent = lp.Character end
                end
            end
            task.wait(1)
        end
    end)
end

-- 8. Logic
KeyBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == "pvpOGS" then
        KeyFrame:Destroy()
        MainFrame.Visible = true
        MinBtn.Visible = true
        if lp.Name == "city800" then
            print("THREAT DETECTED: Crimson Badge Applied")
        end
        StartGrabber()
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "INVALID KEY"
    end
end)

-- 9. Runtime Execution
RunService.Heartbeat:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then ApplyHitbox(p.Character) end
    end
end)
