-- Moon Project 🌑 V3.5 (Full Customization)
local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local PlayerGui = LPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if PlayerGui:FindFirstChild("MoonV3_Final") then PlayerGui.MoonV3_Final:Destroy() end

local MoonGui = Instance.new("ScreenGui", PlayerGui)
MoonGui.Name = "MoonV3_Final"
MoonGui.ResetOnSpawn = false

-- ПЕРЕМЕННЫЕ ДЛЯ ФУНКЦИЙ
local SpeedValue = 16
local FlySpeed = 50
local Flying = false

-- 1. ИКОНКА ОТКРЫТИЯ (Месяц)
local OpenBtn = Instance.new("ImageButton", MoonGui)
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 60)
OpenBtn.Image = "rbxassetid://605124567" 
OpenBtn.Active = true
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local MoonLabel = Instance.new("TextLabel", OpenBtn) -- Запасной месяц если ID не сработает
MoonLabel.Size = UDim2.new(1,0,1,0)
MoonLabel.Text = "🌙"
MoonLabel.BackgroundTransparency = 1
MoonLabel.TextSize = 30
MoonLabel.TextColor3 = Color3.new(1,1,1)

-- 2. ГЛАВНОЕ ОКНО
local Main = Instance.new("Frame", MoonGui)
Main.Name = "Main"
Main.Size = UDim2.new(0, 350, 0, 380)
Main.Position = UDim2.new(0.5, -175, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
Main.Visible = false
Main.Active = true
Main.Draggable = true -- Теперь меню можно перемещать!
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

-- ПЕРЕЛИВАЮЩИЙСЯ ЗАГОЛОВОК (RGB/Black-White)
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "MOON PROJECT 🌑"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 26
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)

spawn(function()
    while task.wait() do
        local t = tick()
        local color = math.sin(t * 2) * 0.5 + 0.5 -- Плавный переход 0 к 1
        Title.TextColor3 = Color3.new(color, color, color) -- Перелив от черного к белому
    end
end)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn)

local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1, -20, 1, -80)
Content.Position = UDim2.new(0, 10, 0, 70)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 2
local ContentList = Instance.new("UIListLayout", Content)
ContentList.Padding = UDim.new(0, 10)

-- ФУНКЦИЯ СОЗДАНИЯ СЛАЙДЕРА (Slider)
local function CreateSlider(name, min, max, default, callback)
    local Frame = Instance.new("Frame", Content)
    Frame.Size = UDim2.new(1, -10, 0, 60)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    Instance.new("UICorner", Frame)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.Text = name .. ": " .. default
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.BackgroundTransparency = 1
    
    local SliderBar = Instance.new("Frame", Frame)
    SliderBar.Size = UDim2.new(0.8, 0, 0, 6)
    SliderBar.Position = UDim2.new(0.1, 0, 0.7, 0)
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    
    local SliderDot = Instance.new("TextButton", SliderBar)
    SliderDot.Size = UDim2.new(0, 16, 0, 16)
    SliderDot.Position = UDim2.new((default-min)/(max-min), -8, 0.5, -8)
    SliderDot.Text = ""
    SliderDot.BackgroundColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", SliderDot).CornerRadius = UDim.new(1,0)

    SliderDot.MouseButton1Down:Connect(function()
        local MoveConn
        MoveConn = UIS.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local relativeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                SliderDot.Position = UDim2.new(relativeX, -8, 0.5, -8)
                local value = math.floor(min + (max - min) * relativeX)
                Label.Text = name .. ": " .. value
                callback(value)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if MoveConn then MoveConn:Disconnect() end
            end
        end)
    end)
end

-- === ЧИТЫ ===

-- Speed Slider
CreateSlider("WalkSpeed", 16, 300, 16, function(v)
    SpeedValue = v
    if LPlayer.Character and LPlayer.Character:FindFirstChild("Humanoid") then
        LPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

-- Fly Slider & Toggle
CreateSlider("Fly Speed", 10, 500, 50, function(v)
    FlySpeed = v
end)

local FlyToggle = Instance.new("TextButton", Content)
FlyToggle.Size = UDim2.new(1, -10, 0, 40)
FlyToggle.Text = "Toggle Fly: OFF"
FlyToggle.BackgroundColor3 = Color3.fromRGB(40, 50, 80)
FlyToggle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", FlyToggle)

FlyToggle.MouseButton1Click:Connect(function()
    Flying = not Flying
    FlyToggle.Text = "Toggle Fly: " .. (Flying and "ON" or "OFF")
    FlyToggle.BackgroundColor3 = Flying and Color3.fromRGB(50, 150, 100) or Color3.fromRGB(40, 50, 80)
    
    if Flying then
        local bv = Instance.new("BodyVelocity", LPlayer.Character.HumanoidRootPart)
        bv.Name = "MoonFly"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        
        spawn(function()
            while Flying do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * FlySpeed
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

-- Логика кнопок
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

RunService.RenderStepped:Connect(function()
    if LPlayer.Character and LPlayer.Character:FindFirstChild("Humanoid") then
        LPlayer.Character.Humanoid.WalkSpeed = SpeedValue
    end
end)
