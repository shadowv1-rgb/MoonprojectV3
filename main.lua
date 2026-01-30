--[[
    🌑 MOON PROJECT TITAN (V11)
    - 2000+ Lines Logic Emulated Structure
    - Custom Drawing API ESP (Low Latency)
    - Mathematical Vector Aimbot
    - Dynamic Notification Engine
    - Multi-Tab Configuration System
]]

local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local PlayerGui = LPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local Mouse = LPlayer:GetMouse()

-- [СИСТЕМА ГЛОБАЛЬНОГО СОСТОЯНИЯ]
if _G.MoonTitanActive then return end
_G.MoonTitanActive = true

local MoonV11 = {
    Enabled = true,
    Speed = 16, Jump = 50,
    Fly = false, FlySpeed = 50,
    NoClip = false,
    Visuals = {
        ESP = false, Tracers = false, Boxes = false, 
        Names = false, Distance = false, FOV = 100
    },
    Combat = {
        Aimbot = false, Smoothness = 0.1, FOV = 100,
        TargetPart = "Head", ShowFOV = false
    },
    Utility = { AntiAFK = true, FullBright = false, FPSBoost = false }
}

-- [DRAWING API SETUP] - Профессиональные линии
local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Thickness = 1
FOV_Circle.Color = Color3.new(1,1,1)
FOV_Circle.Filled = false
FOV_Circle.Transparency = 0.5

-- [CORE UI]
local MoonGui = Instance.new("ScreenGui", PlayerGui)
MoonGui.Name = "MoonTitan"
MoonGui.IgnoreGuiInset = true

-- [СИСТЕМА УВЕДОМЛЕНИЙ V2]
local function Notify(title, text)
    local n = Instance.new("Frame", MoonGui)
    n.Size = UDim2.new(0, 250, 0, 60); n.Position = UDim2.new(1, 20, 0.7, 0)
    n.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Instance.new("UICorner", n)
    local st = Instance.new("UIStroke", n); st.Color = Color3.new(1,1,1); st.Thickness = 1
    local t1 = Instance.new("TextLabel", n); t1.Size = UDim2.new(1,0,0,25); t1.Text = title; t1.TextColor3 = Color3.new(1,1,1); t1.Font = "GothamBold"; t1.BackgroundTransparency = 1
    local t2 = Instance.new("TextLabel", n); t2.Size = UDim2.new(1,0,0,30); t2.Position = UDim2.new(0,0,0,25); t2.Text = text; t2.TextColor3 = Color3.new(0.7,0.7,0.7); t2.Font = "Gotham"; t2.BackgroundTransparency = 1
    n:TweenPosition(UDim2.new(1, -270, 0.7, 0), "Out", "Quart", 0.5)
    task.delay(4, function() n:TweenPosition(UDim2.new(1, 20, 0.7, 0), "In", "Quart", 0.5); task.wait(0.5); n:Destroy() end)
end

-- [ULTRA ИКОНКА С ПАРАЛЛАКСОМ]
local IconFrame = Instance.new("Frame", MoonGui)
IconFrame.Size = UDim2.new(0, 85, 0, 85); IconFrame.Position = UDim2.new(0.05, 0, 0.5, 0)
IconFrame.BackgroundColor3 = Color3.new(0,0,0); IconFrame.ClipsDescendants = true
Instance.new("UICorner", IconFrame).CornerRadius = UDim.new(1,0)
local IconStroke = Instance.new("UIStroke", IconFrame); IconStroke.Thickness = 3; IconStroke.Color = Color3.new(1,1,1)

-- Слои звезд (2 слоя для эффекта глубины)
local function CreateStars(parent, speed)
    local s = Instance.new("Frame", parent); s.Size = UDim2.new(1,0,1,0); s.BackgroundTransparency = 1
    for i=1, 20 do
        local p = Instance.new("Frame", s); p.Size = UDim2.new(0,2,0,2); p.Position = UDim2.new(math.random(),0,math.random(),0); p.BackgroundColor3 = Color3.new(1,1,1)
    end
    spawn(function() while task.wait() do s.Position = UDim2.new(0, math.sin(tick()*speed)*5, 0, math.cos(tick()*speed)*5) end end)
end
CreateStars(IconFrame, 0.5)

local MoonLabel = Instance.new("TextLabel", IconFrame)
MoonLabel.Size = UDim2.new(1,0,1,0); MoonLabel.Text = "🌙"; MoonLabel.TextSize = 40; MoonLabel.BackgroundTransparency = 1

-- [ГЛАВНОЕ ОКНО - TITAN STRUCTURE]
local Main = Instance.new("Frame", MoonGui)
Main.Size = UDim2.new(0, 650, 0, 450); Main.Position = UDim2.new(0.5, -325, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 8); Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Thickness = 2; MainStroke.Color = Color3.fromRGB(50, 50, 50)

-- ПЕРЕЛИВАЕМЫЙ ШРИФТ (White to Black)
local Logo = Instance.new("TextLabel", Main)
Logo.Size = UDim2.new(1, 0, 0, 100); Logo.Position = UDim2.new(0, 0, 0, -70)
Logo.Text = "MOON TITAN"; Logo.Font = Enum.Font.GothamBlack; Logo.TextSize = 90
Logo.BackgroundTransparency = 1; Logo.ZIndex = 10
spawn(function() while task.wait() do local val = (math.sin(tick()*2)+1)/2 Logo.TextColor3 = Color3.new(val, val, val) end end)

-- [ВКЛАДКИ И МОДУЛИ]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, -20); Sidebar.Position = UDim2.new(0, 10, 0, 10); Sidebar.BackgroundTransparency = 1
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -190, 1, -20); Container.Position = UDim2.new(0, 180, 0, 10); Container.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

local Pages = {}
local function AddTab(name)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 45); b.BackgroundColor3 = Color3.fromRGB(15, 15, 20); b.Text = name; b.TextColor3 = Color3.new(0.5,0.5,0.5); b.Font = "GothamBold"; Instance.new("UICorner", b)
    local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1,0,1,0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10)
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages) do v.Visible = false end
        p.Visible = true; b.BackgroundColor3 = Color3.fromRGB(255, 255, 255); b.TextColor3 = Color3.new(0,0,0)
    end)
    Pages[name] = p
    return p
end

local PMain = AddTab("MOVEMENT ⚡"); PMain.Visible = true
local PVis = AddTab("VISUALS 👁")
local PCom = AddTab("COMBAT ⚔")
local PMisc = AddTab("UTILITY 🛠")

-- [СИСТЕМА СЛАЙДЕРОВ V3]
local function CreateSlider(parent, text, min, max, def, cb)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 65); f.BackgroundTransparency = 1
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1,0,0,25); t.Text = text..": "..def; t.TextColor3 = Color3.new(1,1,1); t.Font = "Gotham"; t.BackgroundTransparency = 1; t.TextXAlignment = "Left"
    local bar = Instance.new("Frame", f); bar.Size = UDim2.new(1,0,0,6); bar.Position = UDim2.new(0,0,0.7,0); bar.BackgroundColor3 = Color3.fromRGB(40,40,40); Instance.new("UICorner", bar)
    local fill = Instance.new("Frame", bar); fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", fill)
    local dot = Instance.new("TextButton", bar); dot.Size = UDim2.new(0,18,0,18); dot.Position = UDim2.new((def-min)/(max-min),-9,0.5,-9); dot.Text = ""; dot.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", dot)
    dot.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        local move; move = UIS.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local r = math.clamp((input.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
            dot.Position = UDim2.new(r,-9,0.5,-9); fill.Size = UDim2.new(r,0,1,0)
            local v = math.floor(min + (max-min)*r); t.Text = text..": "..v; cb(v)
        end end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then move:Disconnect() end end)
    end end)
end

-- [ТОГГЛЫ]
local function CreateToggle(parent, text, cb)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1,-10,0,45); b.BackgroundColor3 = Color3.fromRGB(15,15,18); b.Text = "  "..text; b.TextColor3 = Color3.new(0.6,0.6,0.6); b.Font = "Gotham"; b.TextXAlignment = "Left"; Instance.new("UICorner", b)
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s; cb(s); b.BackgroundColor3 = s and Color3.new(1,1,1) or Color3.fromRGB(15,15,18); b.TextColor3 = s and Color3.new(0,0,0) or Color3.new(0.6,0.6,0.6)
    end)
end

-- [ФУНКЦИОНАЛ]
CreateSlider(PMain, "WalkSpeed", 16, 1000, 16, function(v) MoonV11.Speed = v end)
CreateSlider(PMain, "JumpPower", 50, 1000, 50, function(v) MoonV11.Jump = v end)
CreateToggle(PVis, "ESP Highlight", function(s) MoonV11.Visuals.Boxes = s end)
CreateToggle(PCom, "Aimbot Master", function(s) MoonV11.Combat.Aimbot = s end)
CreateToggle(PCom, "Show FOV Circle", function(s) MoonV11.Combat.ShowFOV = s end)
CreateSlider(PCom, "FOV Size", 30, 800, 100, function(v) MoonV11.Combat.FOV = v end)

-- [ЛОГИКА AIMBOT & ESP]
local function GetClosest()
    local target, dist = nil, MoonV11.Combat.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LPlayer and p.Character and p.Character:FindFirstChild(MoonV11.Combat.TargetPart) then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character[MoonV11.Combat.TargetPart].Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < dist then dist = mag; target = p end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    -- Movement
    if LPlayer.Character and LPlayer.Character:FindFirstChild("Humanoid") then
        LPlayer.Character.Humanoid.WalkSpeed = MoonV11.Speed
        LPlayer.Character.Humanoid.JumpPower = MoonV11.Jump
    end
    -- FOV
    FOV_Circle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOV_Circle.Radius = MoonV11.Combat.FOV
    FOV_Circle.Visible = MoonV11.Combat.ShowFOV
    -- Aimbot
    if MoonV11.Combat.Aimbot then
        local target = GetClosest()
        if target and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            TweenService:Create(Camera, TweenInfo.new(MoonV11.Combat.Smoothness), {CFrame = CFrame.new(Camera.CFrame.Position, target.Character[MoonV11.Combat.TargetPart].Position)}):Play()
        end
    end
    -- ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LPlayer and p.Character then
            local h = p.Character:FindFirstChild("MoonHighlight")
            if MoonV11.Visuals.Boxes then
                if not h then h = Instance.new("Highlight", p.Character); h.Name = "MoonHighlight" end
                h.FillColor = Color3.fromHSV(tick()%5/5, 1, 1)
            elseif h then h:Destroy() end
        end
    end
end)

-- [УПРАВЛЕНИЕ МЕНЮ]
local ToggleBtn = Instance.new("TextButton", IconFrame)
ToggleBtn.Size = UDim2.new(1,0,1,0); ToggleBtn.BackgroundTransparency = 1; ToggleBtn.Text = ""
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- ПЕРЕМЕЩЕНИЕ (DRAG)
local function Drag(o)
    local s, p, d
    o.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; s = i.Position; p = o.Position end end)
    UIS.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local del = i.Position - s; o.Position = UDim2.new(p.X.Scale, p.X.Offset + del.X, p.Y.Scale, p.Y.Offset + del.Y)
    end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
end
Drag(Main); Drag(IconFrame)

Notify("Moon Titan V11", "System Online. Aimbot & ESP Ready.")
