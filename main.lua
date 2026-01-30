-- Moon Project 🌑 V3 (Official)
local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local PlayerGui = LPlayer:WaitForChild("PlayerGui")

-- Удаление дубликатов
if PlayerGui:FindFirstChild("MoonV3") then PlayerGui.MoonV3:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoonV3"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- 1. МАЛЕНЬКИЙ КВАДРАТ (Кнопка открытия)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Parent = ScreenGui
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
OpenBtn.Text = "🌑"
OpenBtn.TextSize = 30
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 12)

-- 2. ГЛАВНОЕ МЕНЮ (Квадрат Moon Project)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 280, 0, 240)
Main.Position = UDim2.new(0.5, -140, 0.5, -120)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

-- Эффект белых звезд (размытие фона)
for i = 1, 25 do
    local star = Instance.new("Frame", Main)
    star.Size = UDim2.new(0, 2, 0, 2)
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.new(1, 1, 1)
    star.BackgroundTransparency = 0.5
    star.BorderSizePixel = 0
end

-- Заголовок
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "moon project🌑"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

-- Кнопка-крестик (Закрыть)
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 7)
Close.Text = "✕"
Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)

-- ФУНКЦИИ (Примеры)
local SpeedBtn = Instance.new("TextButton", Main)
SpeedBtn.Size = UDim2.new(0, 200, 0, 40)
SpeedBtn.Position = UDim2.new(0.5, -100, 0, 60)
SpeedBtn.Text = "Speed Hack (50)"
SpeedBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
SpeedBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SpeedBtn)

SpeedBtn.MouseButton1Click:Connect(function()
    LPlayer.Character.Humanoid.WalkSpeed = 50
end)

-- Логика кнопок
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

print("Moon Project V3 Loaded! 🌑")
