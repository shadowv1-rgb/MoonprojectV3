-- Moon Project 🌑 V5.1 (STABLE FIX)
local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local PlayerGui = LPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Удаление старых версий перед запуском
if PlayerGui:FindFirstChild("MoonV5") then PlayerGui.MoonV5:Destroy() end

local MoonGui = Instance.new("ScreenGui", PlayerGui)
MoonGui.Name = "MoonV5"
MoonGui.ResetOnSpawn = false

-- Переменные
local SpeedValue = 16
local FlySpeed = 50
local Flying = false
local ESP_Enabled = false
local AntiAFK_Enabled = false

-- 1. ИКОНКА (🌙)
local OpenBtn = Instance.new("ImageButton", MoonGui)
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 60)
OpenBtn.Active = true
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local MoonLabel = Instance.new("TextLabel", OpenBtn)
MoonLabel.Size = UDim2.new(1,0,1,0)
MoonLabel.Text = "🌙"
MoonLabel.BackgroundTransparency = 1
MoonLabel.TextSize = 30
MoonLabel.TextColor3 = Color3.new(1,1,1)

-- 2. ГЛАВНОЕ МЕНЮ
local Main = Instance.new("Frame", MoonGui)
Main.Size = UDim2.new(0, 360, 0, 320)
Main.Position = UDim2.new(0.5, -180, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

-- RGB ТЕКСТ
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "MOON PROJECT 🌑"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.BackgroundTransparency = 1
spawn(function()
    while task.wait() do
        local c = math.sin(tick()*2)*0.5+0.5
        Title.TextColor3 = Color3.new(c,c,c)
    end
end)

-- ВКЛАДКИ
local TabBar = Instance.new("Frame", Main)
TabBar.Size = UDim2.new(1, 0, 0, 35)
TabBar.Position = UDim2.new(0, 0, 0, 50)
TabBar.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", TabBar)
UIList.FillDirection = Enum.FillDirection.Horizontal
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 10)

local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -20, 1, -100)
Pages.Position = UDim2.new(0, 10, 0, 90)
Pages.BackgroundTransparency = 1

local function CreatePage()
    local p = Instance.new("ScrollingFrame", Pages)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10)
    return p
end

local PageMain = CreatePage(); PageMain.Visible = true
local PageVisuals = CreatePage()
local PageSettings = CreatePage()

local function CreateTab(name, page)
    local b = Instance.new("TextButton", TabBar)
    b.Size = UDim2.new(0, 100, 1, 0)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(30, 35, 55)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        PageMain.Visible = false; PageVisuals.Visible = false; PageSettings.Visible = false
        page.Visible = true
    end)
end

CreateTab("MAIN", PageMain)
CreateTab("VISUALS", PageVisuals)
CreateTab("SETTINGS", PageSettings)

-- КОНСТРУКТОРЫ
local function CreateToggle(parent, name, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    b.Text = name .. ": OFF"
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Gotham
    Instance.new("UICorner", b)
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s
        b.Text = name .. ": " .. (s and "ON" or "OFF")
        b.BackgroundColor3 = s and Color3.fromRGB(50, 150, 80) or Color3.fromRGB(25, 30, 45)
        callback(s)
    end)
end

local function CreateSlider(parent, name, min, max, def, callback)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 55); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 25); l.Text = name .. ": " .. def; l.TextColor3 = Color3.new(1, 1, 1); l.BackgroundTransparency = 1
    local b = Instance.new("Frame", f); b.Size = UDim2.new(0.9, 0, 0, 4); b.Position = UDim2.new(0.05, 0, 0.75, 0); b.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    local d = Instance.new("TextButton", b); d.Size = UDim2.new(0, 16, 0, 16); d.Position = UDim2.new((def-min)/(max-min), -8, 0.5, -8); d.Text = ""; Instance.new("UICorner", d)
    
    d.MouseButton1Down:Connect(function()
        local move; move = UIS.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local rel = math.clamp((input.Position.X - b.AbsolutePosition.X) / b.AbsoluteSize.X, 0, 1)
                d.Position = UDim2.new(rel, -8, 0.5, -8)
                local val = math.floor(min + (max-min)*rel); l.Text = name .. ": " .. val; callback(val)
            end
        end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then move:Disconnect() end end)
    end)
end

-- ФУНКЦИИ
CreateSlider(PageMain, "WalkSpeed", 16, 500, 16, function(v) SpeedValue = v end)
CreateSlider(PageMain, "Fly Speed", 10, 500, 50, function(v) FlySpeed = v end)
CreateToggle(PageMain, "Fly Mode", function(s)
    Flying = s
    if s and LPlayer.Character then
        local bv = Instance.new("BodyVelocity", LPlayer.Character.HumanoidRootPart)
        bv.Name = "MoonFly"; bv.MaxForce = Vector3.new(1e6,1e6,1e6)
        spawn(function()
            while Flying do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * FlySpeed
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

CreateToggle(PageVisuals, "ESP Players", function(s) ESP_Enabled = s end)
CreateToggle(PageSettings, "Anti-AFK", function(s) AntiAFK_Enabled = s end)

-- ЦИКЛЫ
RunService.RenderStepped:Connect(function()
    if LPlayer.Character and LPlayer.Character:FindFirstChild("Humanoid") then
        LPlayer.Character.Humanoid.WalkSpeed = SpeedValue
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LPlayer and p.Character then
            if ESP_Enabled then
                if not p.Character:FindFirstChild("MoonHighlight") then
                    local h = Instance.new("Highlight", p.Character); h.Name = "MoonHighlight"; h.FillColor = Color3.new(0.5, 0.5, 1)
                end
            else
                if p.Character:FindFirstChild("MoonHighlight") then p.Character.MoonHighlight:Destroy() end
            end
        end
    end
end)

LPlayer.Idled:Connect(function()
    if AntiAFK_Enabled then
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- Кнопки управления
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -35, 0, 10); Close.Text = "✕"; Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50); Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

print("Moon Project V5.1 Loaded!")
