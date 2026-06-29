-- DEATH WATCHERS | ULTIMATE PVP MATRIX ENGINE (COMPACT V8)
local WindUI=loadstring(game:HttpGet("https://rawusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local RunService,Players,Stats,TeleportService,LP=game:GetService("RunService"),game:GetService("Players"),game:GetService("Stats"),game:GetService("TeleportService"),game:GetService("Players").LocalPlayer
local Window=WindUI:CreateWindow({Title="DEATH WATCHERS | MULTI-MATRIX",Icon="shield",Author="DW Clan Core",Folder="DeathWatchers_WindUI",Size=UDim2.fromOffset(580,520),Theme="Dark"})
_G.Settings={UseTools=false,Respawn=false,ToolGrabber=true,Loopbring=false,KillAura=false,HitboxExpander=false,HitboxSize=12,HitAmplifier=false,ToolFollow=false,ZeroCooldown=false}
_G.BringTargets,getgenv().configs,modifiedHitboxes,cachedToolParts,cachedTargetTorsos={}, {connections={},Size=Vector3.new(30,30,30),TargetList={}},{},{},{}

-- Dynamic 0 Cooldown Hook Engine
local oWait, oTWait, oDelay, oSpawn
pcall(function()
    oWait = hookfunction(wait, function(...) if _G.Settings.ZeroCooldown then return RunService.PostSimulation:Wait() else return oWait(...) end end)
    oTWait = hookfunction(task.wait, function(...) if _G.Settings.ZeroCooldown then return RunService.PostSimulation:Wait() else return oTWait(...) end end)
    oDelay = hookfunction(delay, function(t, f) if _G.Settings.ZeroCooldown then return task.spawn(f) else return oDelay(t, f) end end)
    oSpawn = hookfunction(spawn, function(f) if _G.Settings.ZeroCooldown then return task.spawn(f) else return oSpawn(f) end end)
end)

local Tycoons=workspace:WaitForChild("Tycoons",5) local allowedBases={Stone=true,Magic=true,Storm=true,Robotic=true} local excludedBases={Insanity=true,Giant=true,Dark=true,Spike=true,Web=true,Strong=true} local toolToBase={["Energy Sword"]="Stone",["Staff"]="Magic",["Axe"]="Storm",["Fist"]="Robotic"} local padsByBase,activeLoops={}
local function registerPad(p) local b=p.Parent and p.Parent.Parent if not b or excludedBases[b.Name] or not allowedBases[b.Name] then return end padsByBase[b.Name]=padsByBase[b.Name] or {} table.insert(padsByBase[b.Name],p) end
if Tycoons then for _,d in ipairs(Tycoons:GetDescendants()) do if d:IsA("TouchTransmitter") and d.Parent.Parent.Name:find("GearGiver1") then registerPad(d.Parent) end end end
local function hasSpecificTool(n) local function s(c) if not c then return false end for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") and t.Name==n then return true end end return false end return s(LP.Backpack) or s(LP.Character) end
local function runParallelGrabLoop(tn) if activeLoops[tn] or not _G.Settings.ToolGrabber then return end local b=toolToBase[tn] if not b then return end activeLoops[tn]=true task.spawn(function() while activeLoops[tn] and _G.Settings.ToolGrabber do if hasSpecificTool(tn) then activeLoops[tn]=nil break end local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if root and padsByBase[b] then for _,p in ipairs(padsByBase[b]) do for i=1,8 do firetouchinterest(root,p,0) firetouchinterest(root,p,1) end end end RunService.Heartbeat:Wait() end activeLoops[tn]=nil end) end
local function triggerQuantumGrab() if not _G.Settings.ToolGrabber then return end for tn in pairs(toolToBase) do runParallelGrabLoop(tn) end end
local function getToolPart(t) return t:FindFirstChild("Handle") or t.PrimaryPart or t:FindFirstChildWhichIsA("BasePart") end
local function updateToolCache() table.clear(cachedToolParts) if not LP.Character then return end for _,t in ipairs(LP.Character:GetChildren()) do if t:IsA("Tool") then local p=getToolPart(t) if p then table.insert(cachedToolParts,p) end end end end
local function fixToolPhysics(t) if not t:IsA("Tool") then return end t.GripPos=Vector3.new(0,0,0) local p=getToolPart(t) if p then p.CanCollide=false p.Massless=true end end
local function equipTools() local c,b=LP.Character,LP.Backpack if not c or not b then return end for _,t in ipairs(b:GetChildren()) do if t:IsA("Tool") and t.Parent~=c then t.Parent=c end end end
local function activateTools() local c=LP.Character if not c then return end for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then pcall(t.Activate,t) end end end
local ReplicatedStorage=game:GetService("ReplicatedStorage") local GuideEvent=ReplicatedStorage:FindFirstChild("Guide") local respawnFired=false
local function executeInstantRespawn() if respawnFired or not _G.Settings.Respawn then return end respawnFired=true local f=function() pcall(function() if GuideEvent then GuideEvent:FireServer() else LP:LoadCharacter() end end) end f() task.delay(0.02,f) task.delay(0.2,function() respawnFired=false end) end

-- UI Layout Configuration
local CombatTab=Window:Tab({Title="PvP Mods",Icon="swords"}) local GlitchTab=Window:Tab({Title="Tycoon Glitch",Icon="zap"}) local TargetTab=Window:Tab({Title="Targeting",Icon="crosshair"}) local AdminTab=Window:Tab({Title="Admin",Icon="terminal"}) local ServerTab=Window:Tab({Title="Server Info",Icon="server"})

CombatTab:Toggle({Title="0 Cooldown Breaker",Value=false,Callback=function(v) _G.Settings.ZeroCooldown=v end})
CombatTab:Toggle({Title="RTX Instant Auto-Use Tools",Value=false,Callback=function(v) _G.Settings.UseTools=v if v then equipTools() end end})
CombatTab:Toggle({Title="Quantum Parallel Tool Grabber",Value=true,Callback=function(v) _G.Settings.ToolGrabber=v if v then triggerQuantumGrab() end end})
CombatTab:Toggle({Title="Pre-Death Instant Respawn Engine",Value=false,Callback=function(v) _G.Settings.Respawn=v end})
CombatTab:Toggle({Title="Optimized Hitbox Expander V2",Value=false,Callback=function(v) _G.Settings.HitboxExpander=v end})
CombatTab:Slider({Title="Hitbox Dimension Radius",Min=2,Max=30,Value=12,Callback=function(v) _G.Settings.HitboxSize=v end})
CombatTab:Toggle({Title="Ultra Smart Hit Amplifier",Value=false,Callback=function(v) _G.Settings.HitAmplifier=v end})
CombatTab:Toggle({Title="Zero-Gravity Torso Tool Follow",Value=false,Callback=function(v) _G.Settings.ToolFollow=v end})

GlitchTab:Button({Title="⚡ Super Fast Same-Server Rejoin",Callback=function() if #Players:GetPlayers()<=1 then TeleportService:Teleport(game.PlaceId,LP) else TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LP) end end})
AdminTab:Button({Title="Load Nameless Admin Tools",Callback=function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Nameless-admin-v250-script-87765"))() end})

TargetTab:Toggle({Title="Targeted Kill Aura Network",Value=false,Callback=function(v) _G.Settings.KillAura=v end})
TargetTab:Toggle({Title="Loopbring Target Vector",Value=false,Callback=function(v) _G.Settings.Loopbring=v end})

-- Heartbeat Logic Execution
RunService.Heartbeat:Connect(function(dt)
 if _G.Settings.UseTools then equipTools() end
 if _G.Settings.HitboxExpander then for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character then local hrp=p.Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.Size=Vector3.new(_G.Settings.HitboxSize,_G.Settings.HitboxSize,_G.Settings.HitboxSize) hrp.CanCollide=false end end end end
 if _G.Settings.KillAura and #getgenv().configs.TargetList>0 and LP.Character then
  local Ignorelist=OverlapParams.new() Ignorelist.FilterType=Enum.RaycastFilterType.Include local targets={}
  for _,p in ipairs(getgenv().configs.TargetList) do if p.Character and p.Character:FindFirstChild("Humanoid") then table.insert(targets,p.Character) end end
  Ignorelist.FilterDescendantsInstances=targets
  for _,tool in ipairs(LP.Character:GetChildren()) do if tool:IsA("Tool") then for _,obj in ipairs(tool:GetDescendants()) do if obj:IsA("TouchTransmitter") then firetouchinterest(obj.Parent,targets[1] or workspace.Terrain,1) firetouchinterest(obj.Parent,targets[1] or workspace.Terrain,0) end end end end
 end
end)
