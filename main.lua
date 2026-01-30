-- Moon Project 🌑 V7 (Ultra High Resolution UI)
local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local PlayerGui = LPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if PlayerGui:FindFirstChild("MoonV7") then PlayerGui.MoonV7:Destroy() end

local MoonGui = Instance.new("ScreenGui", PlayerGui)
MoonGui.Name = "MoonV7"
MoonGui.ResetOnSpawn = false

-- Переменные
local SpeedValue = 16
local FlySpeed = 50
local Flying = false
local ESP_Enabled = false

-- 1. КРУТАЯ ИКОНКА (Месяц + Звезды)
local OpenBtn = Instance.new("ImageButton", MoonGui)
OpenBtn.Size = UDim2.new(0, 75, 0, 75)
OpenBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
OpenBtn.Image = "rbxassetid://605124567" -- Месяц
OpenBtn.Active = true; OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

-- Добавляем звезды на иконку
for i = 1, 15 do
    local s = Instance.new("Frame", OpenBtn)
    s.Size = UDim2.new(0, 2, 0, 2)
    s.Position = UDim2.new(math.random(), 0, math.random(), 0)
    s.BackgroundColor3 = Color3.new(1, 1, 1)
    s.BackgroundTransparency = 0.3
    Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0)
end

-- 2. ГЛАВНОЕ МЕНЮ
local Main = Instance.new("Frame", MoonGui)
Main.Size = UDim2.new(0, 420, 0, 380)
Main.Position = UDim2.new(0.5, -210, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(8, 9, 15)
Main.Visible = false; Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 25)

-- ОГРОМНЫЙ ПЕРЕЛИВАЮЩИЙСЯ ШРИФТ
local BigTitle = Instance.new("TextLabel", Main)
BigTitle.Size = UDim2.new(1, 0, 0, 80)
BigTitle.Position = UDim2.new(0, 0, 0, -30) -- Выходит за край
BigTitle.Text = "MOON PROJECT"
BigTitle.Font = Enum.Font.GothamBlack
BigTitle.TextSize = 45
BigTitle.BackgroundTransparency = 1
BigTitle.ZIndex = 2

spawn(function()
    while task.wait() do
        local hue = tick() % 5 / 5
        BigTitle.TextColor3 = Color3.fromHSV(hue, 0.6, 1)
    end
end)

-- НЕОНОВАЯ ОБВОДКА МЕНЮ (4K)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 3
Stroke.Color = Color3.fromRGB(80, 100, 255)
local Grad = Instance.new("UIGradient", Stroke)
Grad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.new(1,0,1)), ColorSequenceKeypoint.new(1, Color3.new(0,1,1))}

-- ВКЛАДКИ
local TabHold = Instance.new("Frame", Main)
TabHold.Size = UDim2.new(1, -40, 0, 40)
TabHold.Position = UDim2.new(0, 20, 0, 60)
TabHold.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", TabHold); TabList.FillDirection = Enum.FillDirection.Horizontal; TabList.Padding = UDim.new(0, 10)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -40, 1, -130); Container.Position = UDim2.new(0, 20, 0, 110); Container.BackgroundTransparency = 1

local function CreateTab(name, active)
    local b = Instance.new("TextButton", TabHold)
    b.Size = UDim2.new(0, 100, 1, 0); b.Text = name; b.Font = Enum.Font.GothamBold; b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(20, 25, 45); Instance.new("UICorner", b)
    local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1,0,1,0); p.Visible = active; p.BackgroundTransparency = 1; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 12)
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        p.Visible = true
    end)
    return p
end

local PMain = CreateTab("MAIN", true)
local PVis = CreateTab("VISUALS", false)
local PSet = CreateTab("SETTINGS", false)

-- СЛАЙДЕРЫ (ВЕРНУЛ)
local function AddSlider(parent, text, min, max, def, cb)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1,0,0,50); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1,0,0,20); l.Text = text..": "..def; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.TextXAlignment = "Left"
    local b = Instance.new("Frame", f); b.Size = UDim2.new(1,0,0,6); b.Position = UDim2.new(0,0,0.7,0); b.BackgroundColor3 = Color3.fromRGB(40,40,60); Instance.new("UICorner", b)
    local d = Instance.new("TextButton", b); d.Size = UDim2.new(0,18,0,18); d.Position = UDim2.new((def-min)/(max-min),-9,0.5,-9); d.Text = ""; d.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", d)
    d.MouseButton1Down:Connect(function()
        local m; m = UIS.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                local r = math.clamp((i.Position.X - b.AbsolutePosition.X)/b.AbsoluteSize.X, 0, 1)
                d.Position = UDim2.new(r, -9, 0.5, -9)
                local v = math.floor(min + (max-min)*r); l.Text = text..": "..v; cb(v)
            end
        end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then m:Disconnect() end end)
    end)
end

-- ТОГГЛЫ
local function AddToggle(parent, text, cb)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1,0,0,45); b.BackgroundColor3 = Color3.fromRGB(20,22,35); b.Text = "  "..text; b.TextColor3 = Color3.new(0.8,0.8,0.8); b.Font = "Gotham"; b.TextXAlignment = "Left"; Instance.new("UICorner", b)
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s; b.BackgroundColor3 = s and Color3.fromRGB(50,150,100) or Color3.fromRGB(20,22,35); cb(s)
    end)
end

-- НАПОЛНЕНИЕ
AddSlider(PMain, "WalkSpeed", 16, 500, 16, function(v) SpeedValue = v end)
AddSlider(PMain, "Fly Speed", 10, 500, 50, function(v) FlySpeed = v end)
AddToggle(PMain, "Enable Fly", function(state)
    Flying = state
    if state then
        local bv = Instance.new("BodyVelocity", LPlayer.Character.HumanoidRootPart); bv.MaxForce = Vector3.new(1e6,1e6,1e6)
        spawn(function() while Flying do bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * FlySpeed; task.wait() end bv:Destroy() end)
    end
end)

AddToggle(PVis, "ESP Players", function(s) ESP_Enabled = s end)
AddToggle(PSet, "Anti-AFK", function(s) end)

-- ЛОГИКА
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)
local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0,35,0,35); Close.Position = UDim2.new(1,-45,0,10); Close.Text = "✕"; Close.BackgroundColor3 = Color3.fromRGB(200,50,50); Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)

RunService.RenderStepped:Connect(function()
    if LPlayer.Character and LPlayer.Character:FindFirstChild("Humanoid") then LPlayer.Character.Humanoid.WalkSpeed = SpeedValue end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LPlayer and p.Character then
            if ESP_Enabled then
                if not p.Character:FindFirstChild("MoonBox") then local h = Instance.new("Highlight", p.Character); h.Name = "MoonBox" end
            else if p.Character:FindFirstChild("MoonBox") then p.Character.MoonBox:Destroy() end end
        end
    end
end)
